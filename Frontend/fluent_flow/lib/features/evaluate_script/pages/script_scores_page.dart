import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_cubit.dart';
import 'package:flutter/material.dart';
import 'package:fluent_flow/core/const/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class ScriptScoresPage extends StatefulWidget {
  static const String routeName = 'script_scores_page';

  const ScriptScoresPage({Key? key}) : super(key: key);

  @override
  State<ScriptScoresPage> createState() => ScriptScoresPageState();
}

class ScriptScoresPageState extends State<ScriptScoresPage> {
  late double height;
  late double width;
  TextEditingController scriptController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set the initial text and place the cursor at the beginning
    scriptController.text = '';
    scriptController.selection = TextSelection.fromPosition(
      const TextPosition(offset: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(gradient: backgroundGradient),
            height: height,
            width: width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: BackButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35.r),
                          topRight: Radius.circular(35.r)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.01),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Script Scores",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 40.sp,
                                color: fluentNavy,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.05),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Score:',
                                style: TextStyle(
                                  fontSize: 30.sp,
                                  color: fluentNavy,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: CircularProgressIndicator(
                                      value: FluentCubit.get(context).totalScore! / 10,
                                      strokeWidth: 10,
                                      backgroundColor: Colors.amber[200],
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                        Colors.amber,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${FluentCubit.get(context).totalScore!.toStringAsFixed(1)}/10',
                                    style: TextStyle(
                                      fontSize: 35.sp,
                                      fontWeight: FontWeight.bold,
                                      color: fluentNavy,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height * 0.01),
                              Text(
                                'Unique words count in the scripts:',
                                style: TextStyle(
                                  fontSize: 30.sp,
                                  color: fluentNavy,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${FluentCubit.get(context).uniqueTokensCount}',
                                style: TextStyle(
                                  fontSize: 26.sp,
                                  color: fluentBlue,
                                ),
                              ),
                              SizedBox(height: height * 0.01),
                              Text(
                                'Words count in the scripts:',
                                style: TextStyle(
                                  fontSize: 30.sp,
                                  color: fluentNavy,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${FluentCubit.get(context).tokensCount}',
                                style: TextStyle(
                                  fontSize: 26.sp,
                                  color: fluentBlue,
                                ),
                              ),
                              SizedBox(height: height * 0.01),
                              Text(
                                'Stop Words Count in the scripts (stop words: "the", "in", "or", "those"...):',
                                style: TextStyle(
                                  fontSize: 30.sp,
                                  color: fluentNavy,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${FluentCubit.get(context).stopWordsCount}',
                                style: TextStyle(
                                  fontSize: 26.sp,
                                  color: fluentBlue,
                                ),
                              ),
                              SizedBox(height: height * 0.01),
                              Text(
                                'Sentences Count in the scripts:',
                                style: TextStyle(
                                  fontSize: 30.sp,
                                  color: fluentNavy,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${FluentCubit.get(context).sentencesCount}',
                                style: TextStyle(
                                  fontSize: 26.sp,
                                  color: fluentBlue,
                                ),
                              ),
                              SizedBox(height: height * 0.01),
                              Text(
                                'Number of grammatical mistakes in the scripts:',
                                style: TextStyle(
                                  fontSize: 30.sp,
                                  color: fluentNavy,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${FluentCubit.get(context).numberOfGrammaticalError}',
                                style: TextStyle(
                                  fontSize: 26.sp,
                                  color: fluentBlue,
                                ),
                              ),
                              SizedBox(height: height * 0.01),
                              Text(
                                'your script:',
                                style: TextStyle(
                                  fontSize: 30.sp,
                                  color: fluentNavy,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${FluentCubit.get(context).oldText}',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: height * 0.01),
                              Text(
                                'Corrected script:',
                                style: TextStyle(
                                  fontSize: 30.sp,
                                  color: fluentNavy,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${FluentCubit.get(context).correctedText}',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: height * 0.01),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
