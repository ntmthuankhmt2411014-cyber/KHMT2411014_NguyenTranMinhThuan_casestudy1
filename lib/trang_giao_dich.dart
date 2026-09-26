import 'package:flutter/material.dart';

enum TransactionType { expense, income }

class Category {
  final String name;
  final IconData icon;
  const Category(this.name, this.icon);
}

const List<Category> categories = [
  Category('Ăn uống', Icons.restaurant),
  Category('Di chuyển', Icons.directions_car),
  Category('Mua sắm', Icons.shopping_bag),
  Category('Hóa đơn', Icons.receipt_long),
  Category('Khác', Icons.category),
];

/// Widget dùng chung cho cả "Thêm giao dịch" và "Sửa giao dịch".
/// Nếu không truyền các giá trị initial* -> hiển thị như màn hình Thêm (rỗng).
/// Nếu truyền sẵn initialAmount/initialDate/initialNote -> hiển thị như màn hình Sửa.
class TransactionFormScreen extends StatefulWidget {
  final String title;
  final TransactionType initialType;
  final Category? initialCategory;
  final String? initialAmount;
  final String? initialDate;
  final String? initialNote;

  const TransactionFormScreen({
    super.key,
    required this.title,
    this.initialType = TransactionType.expense,
    this.initialCategory,
    this.initialAmount,
    this.initialDate,
    this.initialNote,
  });

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  late TransactionType _type;
  late Category _category;
  late TextEditingController _amountController;
  late TextEditingController _dateController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
    _category = widget.initialCategory ?? categories.first;
    _amountController =
        TextEditingController(text: widget.initialAmount ?? '');
    _dateController = TextEditingController(text: widget.initialDate ?? '');
    _noteController = TextEditingController(text: widget.initialNote ?? '');
  }

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text =
        '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTypeToggle(),
            const SizedBox(height: 24),
            _buildLabel('Danh mục'),
            _buildCategoryDropdown(),
            const SizedBox(height: 20),
            _buildLabel('Số tiền'),
            _buildAmountField(),
            const SizedBox(height: 20),
            _buildLabel('Ngày giao dịch'),
            _buildDateField(),
            const SizedBox(height: 20),
            _buildLabel('Ghi chú'),
            _buildNoteField(),
            const SizedBox(height: 32),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    ),
  );

  Widget _buildTypeToggle() {
    return Row(
      children: [
        Expanded(child: _typeButton('Chi tiêu', TransactionType.expense)),
        const SizedBox(width: 12),
        Expanded(child: _typeButton('Thu nhập', TransactionType.income)),
      ],
    );
  }

  Widget _typeButton(String label, TransactionType type) {
    final bool selected = _type == type;
    return GestureDetector(
      onTap: () => setState(() => _type = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF15B5B) : Colors.white,
          border: Border.all(
            color: selected ? Colors.transparent : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Category>(
          value: _category,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: categories.map((cat) {
            return DropdownMenuItem(
              value: cat,
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF15B5B),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(cat.icon, size: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Text(cat.name),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) setState(() => _category = value);
          },
        ),
      ),
    );
  }

  InputBorder _fieldBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: color),
  );

  Widget _buildAmountField() {
    return TextField(
      controller: _amountController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Nhập số tiền',
        suffixText: 'đ',
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: _fieldBorder(Colors.grey.shade300),
        focusedBorder: _fieldBorder(const Color(0xFF1E5FCC)),
        border: _fieldBorder(Colors.grey.shade300),
      ),
    );
  }

  Widget _buildDateField() {
    return TextField(
      controller: _dateController,
      readOnly: true,
      onTap: _pickDate,
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        enabledBorder: _fieldBorder(Colors.grey.shade300),
        focusedBorder: _fieldBorder(const Color(0xFF1E5FCC)),
        border: _fieldBorder(Colors.grey.shade300),
      ),
    );
  }

  Widget _buildNoteField() {
    return TextField(
      controller: _noteController,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Nhập ghi chú (tùy chọn)',
        contentPadding: const EdgeInsets.all(14),
        enabledBorder: _fieldBorder(Colors.grey.shade300),
        focusedBorder: _fieldBorder(const Color(0xFF1E5FCC)),
        border: _fieldBorder(Colors.grey.shade300),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TransactionFormScreen(
                title: 'Sửa giao dịch',
                initialType: _type,
                initialCategory: _category,
                initialAmount: _amountController.text,
                initialDate: _dateController.text,
                initialNote: _noteController.text,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E5FCC),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: const Text(
          'Lưu',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}