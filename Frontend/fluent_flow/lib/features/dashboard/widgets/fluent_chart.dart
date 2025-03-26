import 'package:fluent_flow/core/const/styles.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class FluentChart extends StatelessWidget {
  FluentChart({
    super.key,
    required this.title,
    required this.data,
    required this.max,
    required this.min,
  });
  String title;
  List<double> data;
  double min;
  double max;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 300,
      child: SfCartesianChart(
        selectionType: SelectionType.point,
        plotAreaBorderWidth: 0,
        tooltipBehavior: TooltipBehavior(
            enable: true, canShowMarker: true, header: title, opacity: 0.7),
        primaryXAxis: NumericAxis(
          rangePadding: ChartRangePadding.round,
          labelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w400, fontSize: 10),
          axisLine: const AxisLine(width: 0),
          labelPosition: ChartDataLabelPosition.outside,
          majorTickLines: const MajorTickLines(width: 0, size: 0),
          majorGridLines: const MajorGridLines(width: 0),
        ),
        primaryYAxis: NumericAxis(minimum: min, maximum: max),
        title: ChartTitle(
          text: title,
          textStyle: TextStyle(
            color: fluentPurple,
            fontWeight: FontWeight.bold,
            fontFamily: 'Quicksand',
          ),
        ),
        series: [
          SplineSeries<double, int>(
            dataSource: data,
            xValueMapper: (double score, int index) => index,
            yValueMapper: (double score, int index) => score,
            color: fluentBlue,
            splineType: SplineType.natural,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          )
        ],
      ),
    );
  }
}