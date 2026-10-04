import 'package:flutter/material.dart';
import '../models/transaction_form.dart';

/// Màn hình Sửa giao dịch -> các field có sẵn dữ liệu
class EditTransactionScreen extends StatelessWidget {
  const EditTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionFormScreen(
      title: 'Sửa giao dịch',
      initialAmount: '100.000',
      initialDate: '12/04/2025',
      initialNote: 'Ăn trưa',
    );
  }
}