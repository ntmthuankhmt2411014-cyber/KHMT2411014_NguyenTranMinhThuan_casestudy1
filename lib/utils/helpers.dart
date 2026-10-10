import 'package:flutter/material.dart';

/// Định dạng số có dấu chấm ngăn cách hàng nghìn, kiểu Việt Nam.
/// Ví dụ: 8000000 -> "8.000.000"
String formatNumber(num value) {
  final absValue = value.abs().toInt();
  final str = absValue.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < str.length; i++) {
    if (i != 0 && (str.length - i) % 3 == 0) buffer.write('.');
    buffer.write(str[i]);
  }
  return buffer.toString();
}

/// Map tên danh mục (lưu dạng text trong database) sang icon hiển thị
IconData iconForCategory(String category) {
  switch (category) {
    case 'Ăn uống':
      return Icons.restaurant;
    case 'Di chuyển':
      return Icons.directions_car;
    case 'Mua sắm':
      return Icons.shopping_cart;
    case 'Hóa đơn':
      return Icons.receipt_long;
    case 'Giáo dục':
      return Icons.school;
    case 'Thu nhập':
      return Icons.attach_money;
    default:
      return Icons.category;
  }
}

/// Map tên danh mục sang màu hiển thị
Color colorForCategory(String category) {
  switch (category) {
    case 'Ăn uống':
      return const Color(0xFFFF6D00);
    case 'Di chuyển':
      return const Color(0xFF2196F3);
    case 'Mua sắm':
      return const Color(0xFF9C27B0);
    case 'Hóa đơn':
      return const Color(0xFF795548);
    case 'Giáo dục':
      return const Color(0xFF009688);
    case 'Thu nhập':
      return const Color(0xFF2EAD4B);
    default:
      return Colors.grey;
  }
}