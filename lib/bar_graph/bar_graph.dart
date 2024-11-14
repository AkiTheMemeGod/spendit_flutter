// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spendit/bar_graph/individual_bar.dart';

class MyBarGraph extends StatefulWidget {
  final List<double> monthlysummary;
  final int startmonth;

  MyBarGraph({
    super.key,
    required this.monthlysummary,
    required this.startmonth,
  });

  @override
  State<MyBarGraph> createState() => _MyBarGraphState();
}

class _MyBarGraphState extends State<MyBarGraph> {
  List<IndividualBar> barData = [];

  void initializeBarData() {
    barData = List.generate(
      widget.monthlysummary.length,
      (index) => IndividualBar(
        x: index,
        y: widget.monthlysummary[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    initializeBarData();
    return BarChart(
      BarChartData(
          minY: 0,
          maxY: 100,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => getBtmTitles(value, meta),
                    reservedSize: 30)),
          ),
          barGroups: barData
              .map(
                (data) => BarChartGroupData(x: data.x, barRods: [
                  BarChartRodData(
                      toY: data.y,
                      width: 20,
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4))
                ]),
              )
              .toList()),
    );
  }

  Widget getBtmTitles(double value, TitleMeta meta) {
    const textstyle = TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    );

    String text;
    switch (value.toInt() % 12) {
      case 0:
        text = 'J';
        break;
      case 1:
        text = 'F';
        break;
      case 2:
        text = 'M';
        break;
      case 3:
        text = 'A';
        break;
      case 4:
        text = 'M';
        break;
      case 5:
        text = 'J';
        break;
      case 6:
        text = 'J';
        break;
      case 7:
        text = 'A';
        break;
      case 8:
        text = 'S';
        break;
      case 9:
        text = 'O';
        break;
      case 10:
        text = 'N';
        break;
      case 11:
        text = 'D';
        break;
      default:
        text = '';
        break;
    }

    return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(
          text,
          style: textstyle,
        ));
  }
}
