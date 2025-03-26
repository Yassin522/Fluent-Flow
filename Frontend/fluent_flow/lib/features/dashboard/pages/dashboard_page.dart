import 'package:fluent_flow/core/const/styles.dart';
import 'package:fluent_flow/core/widgets/loading_widget.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_cubit.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_states.dart';
import 'package:fluent_flow/features/dashboard/models/metric_model.dart';
import 'package:fluent_flow/features/dashboard/widgets/plot_widget.dart';
import 'package:fluent_flow/features/layout/pages/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName = 'dashboard_page';

  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return HomeLayout(
        index: 2,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
            child: BlocConsumer<FluentCubit, FluentState>(
              listener: (context, state) {},
              builder: (context, state) => state is GetScoresLoadingState
                  ? const LoadingWidget(size: 25, stroke: 24)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.01),
                        Text(
                          "Gestures Evaluation History",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28.0,
                              color: fluentNavy),
                        ),
                        SizedBox(height: height * 0.01),
                        const Text(
                          "Check the history of your body language and gestures",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 22.0,
                              color: Colors.blueGrey),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: height * 0.05),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: fluentNavy, width: 3),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Gestures Scores History",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28.0,
                                    color: fluentNavy),
                              ),
                              Icon(
                                Icons.sports_score_rounded,
                                color: fluentNavy,
                                size: 40,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                        for (int i = 0; i < gesturesScoresMetrics.length; i++)
                          PlotWidget(
                              metricModel: gesturesScoresMetrics[i],
                              data: FluentCubit.get(context).gesturesScores[i]),
                        SizedBox(height: height * 0.05),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: fluentNavy, width: 3),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Gestures Analytics History",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28.0,
                                    color: fluentNavy),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                Icons.stacked_line_chart_rounded,
                                color: fluentNavy,
                                size: 35,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                        for (int i = 0;
                            i < gesturesAnalyticsMetrics.length;
                            i++)
                          PlotWidget(
                              metricModel: gesturesAnalyticsMetrics[i],
                              data: FluentCubit.get(context)
                                  .gesturesAnalytics[i]),
                        SizedBox(height: height * 0.05),
                        Text(
                          "Voice Evaluation History",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28.0,
                              color: fluentNavy),
                        ),
                        SizedBox(height: height * 0.05),
                        const Text(
                          "Check the history of assessing the tone, pace, and variation in your speech",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 22.0,
                              color: Colors.blueGrey),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: height * 0.05),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: fluentNavy, width: 3),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Voice Scores History",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28.0,
                                    color: fluentNavy),
                              ),
                              Icon(
                                Icons.sports_score_rounded,
                                color: fluentNavy,
                                size: 40,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                        for (int i = 0; i < voiceScoresMetrics.length; i++)
                          PlotWidget(
                              metricModel: voiceScoresMetrics[i],
                              data: FluentCubit.get(context).voiceScores[i]),
                        SizedBox(height: height * 0.05),
                        Text(
                          "Script Evaluation History",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28.0,
                              color: fluentNavy),
                        ),
                        SizedBox(height: height * 0.01),
                        const Text(
                          "Check the history of analyzing the clarity and structure of your spoken content you did",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 22.0,
                              color: Colors.blueGrey),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: height * 0.05),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: fluentNavy, width: 3),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Script Scores History",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28.0,
                                    color: fluentNavy),
                              ),
                              Icon(
                                Icons.sports_score_rounded,
                                color: fluentNavy,
                                size: 40,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                        for (int i = 0; i < scriptScoresMetrics.length; i++)
                          PlotWidget(
                              metricModel: scriptScoresMetrics[i],
                              data: FluentCubit.get(context).scriptScores[i]),
                        SizedBox(height: height * 0.05),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: fluentNavy, width: 3),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Script Analytics History",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28.0,
                                    color: fluentNavy),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                Icons.stacked_line_chart_rounded,
                                color: fluentNavy,
                                size: 35,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                        for (int i = 0; i < scriptAnalyticsMetrics.length; i++)
                          PlotWidget(
                              metricModel: scriptAnalyticsMetrics[i],
                              data:
                                  FluentCubit.get(context).scriptAnalytics[i]),
                        SizedBox(height: height * 0.05),
                      ],
                    ),
            ),
          ),
        ));
  }
}
