import 'package:fluent_flow/core/const/styles.dart';
import 'package:fluent_flow/core/widgets/loading_widget.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_cubit.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_states.dart';
import 'package:fluent_flow/features/dashboard/models/metric_model.dart';
import 'package:fluent_flow/features/dashboard/widgets/fluent_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PlotWidget extends StatelessWidget {
  const PlotWidget({
    super.key,
    required this.metricModel,
    required this.data,
  });

  final MetricModel metricModel;
  final List<double> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 550.h,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              metricModel.title,
              maxLines: 1,
              style: TextStyle(
                  color: fluentNavy,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.sp),
            ),
            Text(
              metricModel.subtitle,
              maxLines: 2,
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.w500,
                  fontSize: 25.sp),
            ),
            BlocConsumer<FluentCubit, FluentState>(
              listener: (context, state) {},
              builder: (context, state) => Container(
                width: 835.w,
                height: 300.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border:
                      Border.all(color: fluentPurple, width: 2.0),
                ),
                child: state is GetScoresLoadingState
                    ? const LoadingWidget(size: 25, stroke: 24)
                    : FluentChart(title: metricModel.title, data: data, max: metricModel.max, min: metricModel.min),
              ),
            ),
          ]),
    );
  }
}