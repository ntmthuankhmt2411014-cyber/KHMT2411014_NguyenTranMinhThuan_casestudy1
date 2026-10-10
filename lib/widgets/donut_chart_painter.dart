import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/statistic_model.dart';
import '../utils/helpers.dart';

/// Vẽ biểu đồ tròn rỗng giữa (donut) bằng CustomPainter,
/// không cần cài thêm package biểu đồ nào.
class DonutChartPainter extends CustomPainter {
  final List<CategoryStat> stats;
  final double strokeWidth;

  DonutChartPainter({required this.stats, this.strokeWidth = 38});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    // Chưa có dữ liệu -> vẽ vòng xám
    if (stats.isEmpty) {
      final emptyPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = const Color(0xFFE5E7EB);
      canvas.drawArc(rect, 0, 2 * math.pi, false, emptyPaint);
      return;
    }

    double startAngle = -math.pi / 2; // bắt đầu từ đỉnh trên cùng
    final double gap = stats.length > 1 ? 0.03 : 0.0; // khe hở giữa các phần

    for (final stat in stats) {
      final sweep = stat.percent / 100 * 2 * math.pi;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = colorForCategory(stat.category);
      canvas.drawArc(rect, startAngle, math.max(sweep - gap, 0.001), false, paint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant DonutChartPainter oldDelegate) => true;
}