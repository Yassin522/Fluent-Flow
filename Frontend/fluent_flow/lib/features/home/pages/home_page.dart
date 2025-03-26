import 'package:fluent_flow/core/const/api.dart';
import 'package:fluent_flow/core/const/styles.dart';
import 'package:fluent_flow/core/widgets/bubble_image.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_cubit.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_states.dart';
import 'package:fluent_flow/features/evaluate_script/pages/evaluate_script_page.dart';
import 'package:fluent_flow/features/layout/pages/layout.dart';
import 'package:fluent_flow/features/suggested_scripts/pages/suggested_scripts_page.dart';
import 'package:fluent_flow/features/upload_video/pages/video_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  static const String routeName = 'home_page';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double height = constraints.maxHeight;
      double width = constraints.maxWidth;
      return HomeLayout(
        index: 1,
        body: BlocConsumer<FluentCubit, FluentState>(
          listener: (context, state) {},
          builder: (context, state) {
            FluentCubit cubit = FluentCubit.get(context);
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height * 0.05),
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.1),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Hi ${cubit.user.name}',
                        style: TextStyle(
                          fontSize: 35.sp,
                          fontWeight: FontWeight.bold,
                          color: fluentNavy,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.06),
                  BubbleImage(
                    width: width,
                    height: height,
                    imageProvider: cubit.user.imageUrl == "imageUrl" ||
                            cubit.user.imageUrl == null
                        ? const AssetImage('assets/images/anime.jpg')
                        : NetworkImage(IP_PORT + cubit.user.imageUrl!)
                            as ImageProvider,
                  ),
                  SizedBox(height: height * 0.06),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Text(
                      'Let\'s Improve your communication skills with private\n '
                      'and judgement free coaching — powered by AI!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30.sp,
                          color: fluentBlue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                  Text(
                    "Start Now",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 24.sp,
                        color: fluentNavy,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: height * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: fluentPurple,
                          ),
                          child: Text(
                            "Evaluate Video",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20.sp,
                                color: fluentWhite,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, VideoPage.routeName);
                        },
                      ),
                      const SizedBox(width: 40),
                      InkWell(
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: fluentWhite,
                              border:
                                  Border.all(color: fluentPurple, width: 2)),
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
                          Navigator.pushNamed(
                              context, EvaluateScriptsPage.routeName);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Not sure what to say? Check out these suggested scripts for inspiration",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 24.sp,
                            color: fluentNavy,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.05),
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: fluentBlue,
                      ),
                      child: Text(
                        "Suggested Scripts",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20.sp,
                            color: fluentWhite,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                          context, SuggestedScriptsPage.routeName);
                    },
                  ),
                  SizedBox(height: height * 0.05),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45),
                        color: fluentLightPurple,
                        border: Border.all(width: 3)),
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: Text(
                            "Tips for a better result:",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 40.sp,
                                color: fluentWhite,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: Text(
                            '- The video must be in horizontal orientation.\n- Ensure that your upper body is visible throughout the video.\n- You should be the only person visible in the camera frame at all times.\n- Make sure your voice is clear with no background noise.',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 30.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
