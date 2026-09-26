import 'package:flutter/material.dart';
import 'trang_giao_dich.dart';

/// Màn hình Thêm giao dịch -> các field để trống
class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionFormScreen(title: 'Thêm giao dịch');
  }
}