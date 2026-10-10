/// Một giao dịch lấy từ bảng `transactions` trong SQLite.
/// Quy ước: amount < 0 là Chi tiêu, amount >= 0 là Thu nhập.
class TransactionModel {
  final int id;
  final String title;
  final double amount;
  final String date; // dạng dd/MM/yyyy
  final String category;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: map['date'] as String,
      category: map['category'] as String,
    );
  }

  bool get isIncome => amount >= 0;

  /// Chuyển chuỗi "dd/MM/yyyy" thành DateTime để so sánh/sắp xếp.
  DateTime get dateTime {
    final parts = date.split('/');
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }
    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}