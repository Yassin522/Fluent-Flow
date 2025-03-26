import 'package:fluent_flow/core/const/failure_messages.dart';
import 'package:fluent_flow/core/models/video_model.dart';
import 'package:fluent_flow/core/utils/input_validation.dart';
import 'package:fluent_flow/core/utils/show_toast.dart';
import 'package:fluent_flow/core/widgets/loading_widget.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_cubit.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_states.dart';
import 'package:fluent_flow/features/video_score/pages/script_scores_page.dart';
import 'package:flutter/material.dart';
import 'package:fluent_flow/core/const/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class EvaluateScriptsPage extends StatefulWidget {
  static const String routeName = 'evaluate_scripts_page';

  const EvaluateScriptsPage({Key? key}) : super(key: key);

  @override
  State<EvaluateScriptsPage> createState() => EvaluateScriptsPageState();
}

class EvaluateScriptsPageState extends State<EvaluateScriptsPage> {
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
                    )),
                Expanded(
                  child: Container(
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35.r),
                          topRight: Radius.circular(35.r)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: height * 0.06),
                        Text(
                          "Please enter your script below for evaluation and feedback",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 40.sp,
                              color: fluentNavy,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: height * 0.06),
                        SizedBox(
                          width: 1200.w,
                          height: 650.h,
                          child: TextFormField(
                            controller: scriptController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.next,
                            onTap: () => Scrollable.ensureVisible(context),
                            keyboardType: TextInputType.text,
                            // maxLines: 1,
                            validator: (value) {
                              if (!isNotEmptyField(value)) {
                                return emptyFieldMessage;
                              }
                              return null;
                            },
                            style: TextStyle(
                                fontSize: 28.sp, fontWeight: FontWeight.w700),
                            maxLines: null,
                            expands: true,
                          ),
                        ),
                        SizedBox(height: height * 0.06),
                        BlocConsumer<FluentCubit, FluentState>(
                          listener: (context, state) {
                            var get = FluentCubit.get(context);
                            if (state is EvaluateScriptSuccessState) {
                              Video videoX = Video(scriptTotalScore: get.totalScore, uniqueTokensCount: get.uniqueTokensCount!.toInt(), tokensCount: get.tokensCount!.toInt(), transcription: get.oldText, correctedText: get.correctedText, sentencesCount: get.sentencesCount!.toInt(), grammarScore: get.numberOfGrammaticalError, stopWordsCount: get.stopWordsCount!.toInt());
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ScriptXScorePage(video: videoX),
                              ));
                              // Navigator.pushNamed(context, ScriptScoresPage.routeName);
                            }
                            if (state is EvaluateScriptErrorState) {
                              showToast(state.message, context, false);
                            }
                          },
                          builder: (context, state) => state
                                  is EvaluateScriptLoadingState
                              ? const Center(
                                  child: LoadingWidget(size: 26, stroke: 4))
                              : InkWell(
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: fluentWhite,
                                        border: Border.all(
                                            color: fluentPurple, width: 2)),
                                    child: Text(
                                      "Evaluate Script",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          color: fluentPurple,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  onTap: () {
                                    if (scriptController.text.isNotEmpty) {
                                      FluentCubit.get(context).evaluateScript(scriptController.text);
                                    } else {
                                      showToast("Script is empty", context, false);
                                    }
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
