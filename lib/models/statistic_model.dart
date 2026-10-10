import 'transaction_model.dart';

enum StatisticPeriod { thisMonth, lastMonth, thisYear }

/// Số liệu chi tiêu của một danh mục
class CategoryStat {
  final String category;
  final double amount;
  final double percent; // từ 0 đến 100

  const CategoryStat({
    required this.category,
    required this.amount,
    required this.percent,
  });
}

/// Kết quả thống kê chi tiêu theo danh mục trong một khoảng thời gian
class StatisticModel {
  final double totalExpense;
  final List<CategoryStat> stats;

  const StatisticModel({required this.totalExpense, required this.stats});

  static bool isInPeriod(DateTime date, StatisticPeriod period, DateTime now) {
    switch (period) {
      case StatisticPeriod.thisMonth:
        return date.year == now.year && date.month == now.month;
      case StatisticPeriod.lastMonth:
      // DateTime tự xử lý tháng 0 -> tháng 12 của năm trước
        final last = DateTime(now.year, now.month - 1, 1);
        return date.year == last.year && date.month == last.month;
      case StatisticPeriod.thisYear:
        return date.year == now.year;
    }
  }

  factory StatisticModel.fromTransactions(
      List<TransactionModel> transactions,
      StatisticPeriod period,
      ) {
    final now = DateTime.now();
    final Map<String, double> totals = {};

    for (final t in transactions) {
      if (t.isIncome) continue; // chỉ thống kê chi tiêu
      if (!isInPeriod(t.dateTime, period, now)) continue;
      totals[t.category] = (totals[t.category] ?? 0) + t.amount.abs();
    }

    final total = totals.values.fold(0.0, (a, b) => a + b);

    final stats = totals.entries
        .map(
          (e) => CategoryStat(
        category: e.key,
        amount: e.value,
        percent: total == 0 ? 0 : e.value / total * 100,
      ),
    )
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    return StatisticModel(totalExpense: total, stats: stats);
  }
}