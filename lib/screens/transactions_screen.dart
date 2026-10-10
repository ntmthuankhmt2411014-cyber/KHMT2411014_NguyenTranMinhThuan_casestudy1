import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/transaction_form.dart';
import '../models/transaction_model.dart';
import '../utils/helpers.dart';
import '../widgets/choice_chip_button.dart';
import '../widgets/swipe_to_delete.dart';

enum TransactionFilter { all, income, expense }

enum TransactionSort { newest, oldest, highestAmount }

/// Màn hình "Giao dịch": danh sách toàn bộ giao dịch, có tìm kiếm,
/// lọc Tất cả / Thu nhập / Chi tiêu và sắp xếp.
class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<TransactionModel> _all = [];
  bool _loading = true;
  TransactionFilter _filter = TransactionFilter.all;
  TransactionSort _sort = TransactionSort.newest;
  String _keyword = '';

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final data = await DatabaseHelper.instance.getTransactions();
    if (!mounted) return;
    setState(() {
      _all = data.map(TransactionModel.fromMap).toList();
      _loading = false;
    });
  }

  /// Danh sách sau khi áp dụng tìm kiếm + lọc + sắp xếp
  List<TransactionModel> get _visible {
    final keyword = _keyword.trim().toLowerCase();

    final list = _all.where((t) {
      if (_filter == TransactionFilter.income && !t.isIncome) return false;
      if (_filter == TransactionFilter.expense && t.isIncome) return false;
      if (keyword.isEmpty) return true;
      return t.title.toLowerCase().contains(keyword) ||
          t.category.toLowerCase().contains(keyword);
    }).toList();

    list.sort((a, b) {
      switch (_sort) {
        case TransactionSort.newest:
          final c = b.dateTime.compareTo(a.dateTime);
          return c != 0 ? c : b.id.compareTo(a.id);
        case TransactionSort.oldest:
          final c = a.dateTime.compareTo(b.dateTime);
          return c != 0 ? c : a.id.compareTo(b.id);
        case TransactionSort.highestAmount:
          return b.amount.abs().compareTo(a.amount.abs());
      }
    });

    return list;
  }

  /// Gỡ giao dịch khỏi danh sách ngay lập tức (bắt buộc đồng bộ cho Dismissible)
  void _removeLocally(int id) {
    setState(() {
      _all = _all.where((t) => t.id != id).toList();
    });
  }

  Future<void> _openEdit(TransactionModel t) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionFormScreen(
          title: 'Sửa giao dịch',
          transactionId: t.id,
          initialType:
          t.isIncome ? TransactionType.income : TransactionType.expense,
          initialCategory: categories.firstWhere(
                (c) => c.name == t.category,
            orElse: () => categories.first,
          ),
          initialAmount: formatNumber(t.amount),
          initialDate: t.date,
          initialNote: t.title,
        ),
      ),
    );
    if (result == true) {
      _loadTransactions();
    }
  }

  void _showSortSheet() {
    const options = {
      TransactionSort.newest: 'Mới nhất',
      TransactionSort.oldest: 'Cũ nhất',
      TransactionSort.highestAmount: 'Số tiền lớn nhất',
    };

    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Sắp xếp theo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              for (final entry in options.entries)
                ListTile(
                  title: Text(entry.value),
                  trailing: _sort == entry.key
                      ? const Icon(Icons.check, color: Color(0xFF1769E0))
                      : null,
                  onTap: () {
                    setState(() => _sort = entry.key);
                    Navigator.pop(sheetContext);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final items = _visible;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Giao dịch',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildSearchRow(),
          const SizedBox(height: 14),
          _buildFilterChips(),
          const SizedBox(height: 8),
          Expanded(
            child: items.isEmpty
                ? const Center(
              child: Text(
                'Không có giao dịch nào',
                style: TextStyle(color: Color(0xFF667085)),
              ),
            )
                : ListView.separated(
              itemCount: items.length,
              separatorBuilder: (context, index) =>
              const Divider(height: 1),
              itemBuilder: (context, index) {
                final t = items[index];
                return SwipeToDelete(
                  transactionId: t.id,
                  title: t.title,
                  onDeleted: () => _removeLocally(t.id),
                  child: _buildTile(t),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchRow() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: (value) => setState(() => _keyword = value),
            decoration: InputDecoration(
              hintText: 'Tìm kiếm giao dịch...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFF1F3F9),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: _showSortSheet,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.filter_alt_outlined),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Row(
      children: [
        Expanded(
          child: ChoiceChipButton(
            label: 'Tất cả',
            selected: _filter == TransactionFilter.all,
            onTap: () => setState(() => _filter = TransactionFilter.all),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ChoiceChipButton(
            label: 'Thu nhập',
            selected: _filter == TransactionFilter.income,
            onTap: () => setState(() => _filter = TransactionFilter.income),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ChoiceChipButton(
            label: 'Chi tiêu',
            selected: _filter == TransactionFilter.expense,
            onTap: () => setState(() => _filter = TransactionFilter.expense),
          ),
        ),
      ],
    );
  }

  Widget _buildTile(TransactionModel t) {
    return InkWell(
      onTap: () => _openEdit(t),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorForCategory(t.category),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                iconForCategory(t.category),
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t.date,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF667085),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${t.isIncome ? '+' : '-'}${formatNumber(t.amount)} đ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: t.isIncome
                    ? const Color(0xFF2EAD4B)
                    : const Color(0xFFE53935),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: Color(0xFF98A2B3)),
          ],
        ),
      ),
    );
  }
}