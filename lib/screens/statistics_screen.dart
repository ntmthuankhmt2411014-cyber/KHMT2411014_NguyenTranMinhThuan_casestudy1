import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/statistic_model.dart';
import '../models/transaction_model.dart';
import '../utils/helpers.dart';
import '../widgets/choice_chip_button.dart';
import '../widgets/donut_chart_painter.dart';

/// Màn hình "Thống kê": biểu đồ tròn chi tiêu theo danh mục
/// trong Tháng này / Tháng trước / Năm nay.
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<TransactionModel> _all = [];
  bool _loading = true;
  StatisticPeriod _period = StatisticPeriod.thisMonth;

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

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final model = StatisticModel.fromTransactions(_all, _period);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thống kê',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildPeriodChips(),
          const SizedBox(height: 28),
          Center(child: _buildChart(model)),
          const SizedBox(height: 28),
          _buildLegend(model),
        ],
      ),
    );
  }

  Widget _buildPeriodChips() {
    return Row(
      children: [
        Expanded(
          child: ChoiceChipButton(
            label: 'Tháng này',
            selected: _period == StatisticPeriod.thisMonth,
            onTap: () => setState(() => _period = StatisticPeriod.thisMonth),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ChoiceChipButton(
            label: 'Tháng trước',
            selected: _period == StatisticPeriod.lastMonth,
            onTap: () => setState(() => _period = StatisticPeriod.lastMonth),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ChoiceChipButton(
            label: 'Năm nay',
            selected: _period == StatisticPeriod.thisYear,
            onTap: () => setState(() => _period = StatisticPeriod.thisYear),
          ),
        ),
      ],
    );
  }

  Widget _buildChart(StatisticModel model) {
    return SizedBox(
      width: 240,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(240, 240),
            painter: DonutChartPainter(stats: model.stats),
          ),
          // Chữ ở giữa vòng tròn, FittedBox để số lớn không bị tràn
          SizedBox(
            width: 130,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${formatNumber(model.totalExpense)} đ',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tổng chi tiêu',
                  style: TextStyle(fontSize: 14, color: Color(0xFF667085)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(StatisticModel model) {
    if (model.stats.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'Chưa có chi tiêu trong khoảng thời gian này',
            style: TextStyle(color: Color(0xFF667085)),
          ),
        ),
      );
    }

    return Column(
      children: [
        for (final stat in model.stats) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: colorForCategory(stat.category),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    stat.category,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Text(
                  '${formatNumber(stat.amount)} đ',
                  style: const TextStyle(fontSize: 15),
                ),
                SizedBox(
                  width: 52,
                  child: Text(
                    '${stat.percent.round()}%',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF667085),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
        ],
      ],
    );
  }
}