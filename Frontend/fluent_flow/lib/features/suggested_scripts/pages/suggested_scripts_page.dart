import 'package:fluent_flow/core/const/suggested_scripts.dart';
import 'package:flutter/material.dart';
import 'package:fluent_flow/core/const/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class SuggestedScriptsPage extends StatefulWidget {
  static const String routeName = 'suggested_scripts_page';


  const SuggestedScriptsPage({Key? key}) : super(key: key);

  @override
  State<SuggestedScriptsPage> createState() => _SuggestedScriptsPageState();
}

class _SuggestedScriptsPageState extends State<SuggestedScriptsPage> {
  late double height;
  late double width;

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
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  )
                ),
                Expanded(
                  child: Container(
                    width: width,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(35.r), topRight: Radius.circular(35.r)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: height * 0.06),
                        Text(
                          "Suggested Scripts",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 40.sp,
                              color: fluentNavy,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: height * 0.06),
                        Container(
                          width: width,
                          height: height*0.75,
                          padding: EdgeInsets.symmetric(horizontal: width*0.05),
                          child: ListView.builder(
                            itemCount: suggestedScripts.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  CircleAvatar(
                                    radius: width*0.02,
                                    child: Text(
                                      "${index+1}",
                                      style: TextStyle(
                                        fontSize: 40.sp,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: height * 0.04),
                                  Text(
                                    suggestedScripts[index],
                                    style: TextStyle(
                                      fontSize: 30.sp,
                                    ),
                                  ),
                                  const Divider(thickness: 3),
                                  SizedBox(height: height * 0.04),
                                ],
                              );
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

