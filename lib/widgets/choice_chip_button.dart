import 'package:flutter/material.dart';

/// Nút lọc dạng "chip" dùng chung cho màn Giao dịch và Thống kê.
/// Đang chọn -> nền xanh chữ trắng; chưa chọn -> nền trắng viền xám.
class ChoiceChipButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const ChoiceChipButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1769E0) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF1769E0) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF263238),
          ),
        ),
      ),
    );
  }
}