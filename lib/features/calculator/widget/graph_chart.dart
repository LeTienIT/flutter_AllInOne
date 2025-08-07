import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class GraphChart extends StatelessWidget {
  final List<FlSpot> points;

  const GraphChart({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Text('Không có dữ liệu để vẽ.', style: TextStyle(color: Colors.redAccent, fontStyle: FontStyle.italic),),
          )
      );
    }

    final minX = points.map((e) => e.x).reduce(math.min);
    final maxX = points.map((e) => e.x).reduce(math.max);
    final minY = points.map((e) => e.y).reduce(math.min);
    final maxY = points.map((e) => e.y).reduce(math.max);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(13.0),
          child: AspectRatio(
            aspectRatio: 1.6,
            child: LineChart(
              LineChartData(
                minX: minX,
                maxX: maxX,
                minY: minY,
                maxY: maxY,
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 28,),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: points,
                    isCurved: false,
                    color: Colors.blue,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ),
        Text('Dữ liệu x=[-10, 10], Mỗi bước +0.1', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.red, fontSize: 10), textAlign: TextAlign.center,),
      ],
    );
  }
}
