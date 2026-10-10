import 'package:flutter/material.dart';

import '../database/database_helper.dart';

/// Bọc một thẻ giao dịch: vuốt sang PHẢI để xóa.
/// Hiện hộp thoại xác nhận, đồng ý thì xóa khỏi SQLite rồi gọi [onDeleted]
/// để màn hình cha cập nhật lại danh sách.
class SwipeToDelete extends StatelessWidget {
  final int transactionId;
  final String title;
  final Widget child;
  final VoidCallback onDeleted;

  const SwipeToDelete({
    super.key,
    required this.transactionId,
    required this.title,
    required this.child,
    required this.onDeleted,
  });

  Future<bool> _confirmAndDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xóa giao dịch?'),
        content: Text('Bạn có chắc muốn xóa giao dịch "$title" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Xóa',
              style: TextStyle(color: Color(0xFFE53935)),
            ),
          ),
        ],
      ),
    );

    // Bấm Hủy hoặc chạm ra ngoài -> thẻ tự trượt về chỗ cũ
    if (confirmed != true) return false;

    await DatabaseHelper.instance.deleteTransaction(transactionId);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('transaction_$transactionId'),
      direction: DismissDirection.startToEnd, // chỉ cho vuốt sang phải
      background: Container(
        color: const Color(0xFFE53935),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_outline, color: Colors.white, size: 28),
            SizedBox(width: 8),
            Text(
              'Xóa',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) => _confirmAndDelete(context),
      onDismissed: (direction) {
        onDeleted();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã xóa giao dịch')),
        );
      },
      child: child,
    );
  }
}