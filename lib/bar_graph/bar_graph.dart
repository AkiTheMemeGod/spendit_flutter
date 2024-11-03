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
    return BarChart(BarChartData(
      minY: 0,
      maxY: 100,
    ));
  }
}
