import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ComparisonChart extends StatefulWidget {
  final double bankTotal;
  final List<MapEntry<Color, double>> bankSuppliers;
  final double systemTotal;
  final List<MapEntry<Color, double>> systemSuppliers;
  const ComparisonChart(
      {super.key,
      required this.bankTotal,
      required this.bankSuppliers,
      required this.systemTotal,
      required this.systemSuppliers});

  @override
  State<StatefulWidget> createState() => ComparisonChartState();
}

class ComparisonChartState extends State<ComparisonChart> {
  static const double barWidth = 40;
  static const shadowOpacity = 0.2;

  Map<int, List<MapEntry<Color, double>>> mainItems = {};
  int touchedIndex = -1;
  double highestTotal = 0;
  double difference = 0;
  Color diffColor = Colors.red;

  @override
  void initState() {
    super.initState();
    difference = widget.bankTotal - widget.systemTotal;
    if (difference > 0) {
      diffColor = const Color.fromARGB(255, 73, 209, 78);
    }

    mainItems.addAll({
      0: widget.bankSuppliers,
      1: [MapEntry(diffColor, difference)],
      2: widget.systemSuppliers,
    });
    highestTotal = max(widget.bankTotal, widget.systemTotal);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.center,
            maxY: highestTotal + 5000,
            groupsSpace: 40,
            barTouchData: BarTouchData(
              handleBuiltInTouches: false,
              touchCallback: (FlTouchEvent event, barTouchResponse) {
                if (!event.isInterestedForInteractions ||
                    barTouchResponse == null ||
                    barTouchResponse.spot == null) {
                  setState(() {
                    touchedIndex = -1;
                  });
                  return;
                }
                final rodIndex = barTouchResponse.spot!.touchedRodDataIndex;
                if (isShadowBar(rodIndex)) {
                  setState(() {
                    touchedIndex = -1;
                  });
                  return;
                }
                setState(() {
                  touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                });
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              topTitles: const AxisTitles(),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  getTitlesWidget: bottomTitles,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: leftTitles,
                  interval: 10000,
                  reservedSize: 42,
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: rightTitles,
                  interval: 10000,
                  reservedSize: 42,
                ),
              ),
            ),
            gridData: FlGridData(
              show: true,
              checkToShowHorizontalLine: (value) => value % 10000 == 0,
              getDrawingHorizontalLine: (value) {
                if (value == 0) {
                  return FlLine(
                    color: Colors.white.withOpacity(0.3),
                    strokeWidth: 3,
                  );
                }
                return FlLine(
                  color: Colors.white.withOpacity(0.1),
                  strokeWidth: 0.8,
                );
              },
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: mainItems.entries
                .map(
                  (e) => generateGroup(
                    e.key,
                    e.value,
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.white, fontSize: 12);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Extrato';
        break;
      case 1:
        text = 'Diferança';
        break;
      case 2:
        text = 'Sistema';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.white, fontSize: 10);
    String text;
    if (value == 0) {
      text = '0';
    } else {
      text = '${(value / 1000).toInt()}k';
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget rightTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Colors.white, fontSize: 10);
    String text;
    if (value == 0) {
      text = '0';
    } else {
      text = '${(value / 1000).toInt()}k';
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(
        text,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  BarChartGroupData generateGroup(
    int xPosition,
    List<MapEntry<Color, double>> suppliers,
  ) {
    final values = suppliers.map((e) => e.value).toList();
    final colors = suppliers.map((e) => e.key).toList();
    final sum = values.fold(0.0, (a, b) => a + b);
    final isTouched = touchedIndex == xPosition;
    return BarChartGroupData(
      x: xPosition,
      groupVertically: true,
      showingTooltipIndicators: isTouched ? [0] : [],
      barRods: [
        BarChartRodData(
          toY: sum.abs(),
          width: barWidth,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
          rodStackItems: List.generate(values.length, (index) {
            return BarChartRodStackItem(
              //fromY
              index == 0
                  ? 0
                  : values.sublist(0, index).fold(0.0, (a, b) => a + b),
              //toY
              index == 0
                  ? values[0]
                  : values.sublist(0, index + 1).fold(0.0, (a, b) => a + b),
              //color
              colors[index],
              BorderSide(
                color: Colors.white,
                width: isTouched ? 2 : 0,
              ),
            );
          }),
        ),
      ],
    );
  }

  bool isShadowBar(int rodIndex) => rodIndex == 1;
}
