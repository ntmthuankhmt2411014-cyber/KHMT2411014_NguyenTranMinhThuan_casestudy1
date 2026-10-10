import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/transaction_form.dart';
import '../utils/helpers.dart';
import '../widgets/swipe_to_delete.dart';
import 'add_transaction_screen.dart';
import 'profile_screen.dart';
import 'statistics_screen.dart';
import 'transactions_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  // GlobalKey để HomePage có thể gọi hàm reloadTransactions() của HomeContent
  // từ bên ngoài, sau khi màn Thêm giao dịch đóng lại.
  final GlobalKey<HomeContentState> _homeContentKey =
  GlobalKey<HomeContentState>();

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeContent(key: _homeContentKey),
      const TransactionsScreen(),
      const StatisticsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: SafeArea(child: pages[currentIndex]),
      floatingActionButton: currentIndex == 0
          ? FloatingActionButton(
        backgroundColor: const Color(0xFF1769E0),
        foregroundColor: Colors.white,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );
          // Nếu vừa lưu giao dịch mới thành công -> load lại danh sách
          if (result == true) {
            _homeContentKey.currentState?.reloadTransactions();
          }
        },
        child: const Icon(Icons.add, size: 36),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF1769E0),
        unselectedItemColor: const Color(0xFF263238),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            activeIcon: Icon(Icons.format_list_bulleted),
            label: 'Giao dịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Thống kê',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Cá nhân',
          ),
        ],
      ),
    );
  }
}

/// Giờ đây HomeContent là StatefulWidget để tự load dữ liệu từ SQLite
/// và có thể load lại (reload) sau khi thêm/sửa giao dịch.
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => HomeContentState();
}

class HomeContentState extends State<HomeContent> {
  List<Map<String, dynamic>> _transactions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    reloadTransactions();
  }

  Future<void> reloadTransactions() async {
    final data = await DatabaseHelper.instance.getTransactions();
    if (!mounted) return;
    setState(() {
      _transactions = data;
      _loading = false;
    });
  }

  /// Gỡ giao dịch khỏi danh sách ngay lập tức (không chờ đọc lại database).
  /// Bắt buộc phải làm đồng bộ, nếu không Dismissible sẽ báo lỗi.
  void _removeTransactionLocally(int id) {
    setState(() {
      _transactions = _transactions.where((t) => t['id'] != id).toList();
    });
  }

  double get _totalIncome => _transactions
      .where((t) => (t['amount'] as num) > 0)
      .fold(0.0, (sum, t) => sum + (t['amount'] as num));

  double get _totalExpense => _transactions
      .where((t) => (t['amount'] as num) < 0)
      .fold(0.0, (sum, t) => sum + (t['amount'] as num).abs());

  double get _balance => _totalIncome - _totalExpense;

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Header(),
          const SizedBox(height: 20),
          BalanceCard(balance: _balance),
          const SizedBox(height: 24),
          SummarySection(
            totalIncome: _totalIncome,
            totalExpense: _totalExpense,
          ),
          const SizedBox(height: 32),
          const TransactionHeader(),
          const SizedBox(height: 12),
          TransactionList(
            transactions: _transactions,
            onChanged: reloadTransactions,
            onDeleted: _removeTransactionLocally,
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.menu, size: 32)),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            'Quản lý thu chi',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none, size: 32),
            ),
            Positioned(
              right: 2,
              top: 0,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BalanceCard extends StatelessWidget {
  final double balance;

  const BalanceCard({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4D8CF7), Color(0xFF1769E0)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'SỐ DƯ HIỆN TẠI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.visibility, color: Colors.white, size: 28),
                  ],
                ),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.only(right: 90),
                  child: Text(
                    '${balance < 0 ? '-' : ''}${formatNumber(balance)} đ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 26,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 10),
                    _dot(),
                    const SizedBox(width: 10),
                    _dot(),
                    const SizedBox(width: 10),
                    _dot(),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 15,
            top: 65,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                size: 75,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot() {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.35),
        shape: BoxShape.circle,
      ),
    );
  }
}

class SummarySection extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;

  const SummarySection({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SummaryCard(
            title: 'TỔNG THU NHẬP',
            amount: '${formatNumber(totalIncome)} đ',
            icon: Icons.arrow_downward,
            iconColor: const Color(0xFF2EAD4B),
            backgroundColor: const Color(0xFFEAF8EB),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: SummaryCard(
            title: 'TỔNG CHI TIÊU',
            amount: '${formatNumber(totalExpense)} đ',
            icon: Icons.arrow_upward,
            iconColor: const Color(0xFFE53935),
            backgroundColor: const Color(0xFFFFEFF0),
          ),
        ),
      ],
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: iconColor.withOpacity(0.18),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF374151),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionHeader extends StatelessWidget {
  const TransactionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Giao dịch gần đây',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Xem tất cả',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1769E0),
            ),
          ),
        ),
      ],
    );
  }
}

/// Giờ nhận danh sách giao dịch thật (lấy từ SQLite) thay vì dữ liệu mẫu cố định
class TransactionList extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final VoidCallback onChanged;
  final void Function(int id) onDeleted;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.onChanged,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: const Text(
          'Chưa có giao dịch nào, bấm nút + để thêm',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF667085)),
        ),
      );
    }

    return Container(
      clipBehavior: Clip.antiAlias, // để nền đỏ khi vuốt không tràn ra góc bo
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: transactions.length,
        separatorBuilder: (context, index) {
          return const Divider(height: 1, indent: 20, endIndent: 20);
        },
        itemBuilder: (context, index) {
          final item = transactions[index];
          return TransactionItem(
            transaction: item,
            onChanged: onChanged,
            onDeleted: () => onDeleted(item['id'] as int),
          );
        },
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final VoidCallback onChanged;
  final VoidCallback onDeleted;

  const TransactionItem({
    super.key,
    required this.transaction,
    required this.onChanged,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final double amount = (transaction['amount'] as num).toDouble();
    final bool isIncome = amount >= 0;
    final String categoryName = transaction['category'] as String;
    final String title = transaction['title'] as String;
    final String date = transaction['date'] as String;

    final tile = InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionFormScreen(
              title: 'Sửa giao dịch',
              transactionId: transaction['id'] as int,
              initialType: isIncome
                  ? TransactionType.income
                  : TransactionType.expense,
              initialCategory: categories.firstWhere(
                    (c) => c.name == categoryName,
                orElse: () => categories.first,
              ),
              initialAmount: formatNumber(amount),
              initialDate: date,
              initialNote: title,
            ),
          ),
        );
        // Nếu vừa sửa xong -> báo cho danh sách load lại dữ liệu mới nhất
        if (result == true) {
          onChanged();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: colorForCategory(categoryName),
              child: Icon(
                iconForCategory(categoryName),
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          categoryName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF667085),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF667085),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${isIncome ? '+' : '-'}${formatNumber(amount)} đ',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: isIncome
                    ? const Color(0xFF2EAD4B)
                    : const Color(0xFFE53935),
              ),
            ),
          ],
        ),
      ),
    );
    return SwipeToDelete(
      transactionId: transaction['id'] as int,
      title: title,
      onDeleted: onDeleted,
      child: tile,
    );
  }
}