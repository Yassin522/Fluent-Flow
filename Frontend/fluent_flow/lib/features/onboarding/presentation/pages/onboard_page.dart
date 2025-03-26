import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluent_flow/core/const/styles.dart';
import 'package:fluent_flow/core/models/onboard_item_modele.dart';
import 'package:fluent_flow/core/utils/show_toast.dart';
import 'package:fluent_flow/core/widgets/loading_widget.dart';
import 'package:fluent_flow/features/register/presentation/pages/register_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/onboard_bloc.dart';
import '../bloc/onborad_event.dart';
import '../bloc/onborad_state.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../widgets/onboard_page_view_item.dart';


class OnBoardPage extends StatefulWidget {
  static const String routeName = 'OnBoardPage';
  const OnBoardPage({Key? key}) : super(key: key);

  @override
  State<OnBoardPage> createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {

  late double height;
  late double width;
    
  bool isLast = false, isFirst = true;
  Icon icon = const Icon(Icons.arrow_forward_ios);
  PageController boardController = PageController();

  List<OnBoardItemModel> boarding = [
    OnBoardItemModel(
        image: 'assets/images/1.svg',
        title: "Welcome to Fluent Flow",
        body: "Improve communication skills with personalized training. Overcome fear and build confidence"),
    OnBoardItemModel(
        image: 'assets/images/onboard_2.png',
        title: "Personalized Skill Development",
        body: "Receive tailored recommendations to enhance speaking abilities and become a better communicator"),
    OnBoardItemModel(
        image: 'assets/images/onboard_3.png',
        title: "Empower Your Voice",
        body: "Transform fear into confidence and become a compelling, impactful speaker.\nWelcome!",
      ),
  ];
    
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    var bloc = BlocProvider.of<OnBoardBloc>(context);      
    return BlocListener<OnBoardBloc, OnBoardState>(
      listener: (context, state) {
        if (state is OnBoardErrorState) {
          showToast(state.message, context, false);
        } else if (state is SaveOnBoardFirstTimeSuccessState) {
          Navigator.pushNamedAndRemoveUntil(context, RegisterPage.routeName, (route) => false);
        }
    }, child: SafeArea(
        child: Scaffold(
          body: Container(
            height: height / 1.1,
            padding: const EdgeInsets.all(24),
            child: BlocBuilder<OnBoardBloc, OnBoardState>(
              builder: (context, state) {
                if (state is OnBoardLoadingState || state is SaveOnBoardFirstTimeSuccessState) {
                  return const Center(child: LoadingWidget( size: 25, stroke: 4));
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Visibility(
                            visible: !isFirst,
                            replacement: SizedBox(width: width*0.05),
                            child: TextButton(
                                onPressed: () {
                                  boardController.previousPage(
                                      duration:
                                          const Duration(seconds: 2),
                                      curve: Curves.fastLinearToSlowEaseIn);
                                },
                                child: Text(
                                  'Back',
                                  style: TextStyle(
                                      color: fluentPurple,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                        Image.asset(
                          "assets/images/logo_1.png",
                          width: 200.w,
                          height: 100.h,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                              onPressed: () {
                                bloc.add(CacheOnBoardFirstTimeEvent(
                                    firstTime: false));
                              },
                              child: Text(
                                "skip",
                                style: TextStyle(
                                    color: fluentBlue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(height: height*0.1),
                    Expanded(
                      child: PageView.builder(
                        itemCount: boarding.length,
                        physics: const BouncingScrollPhysics(),
                        onPageChanged: (index) {
                          setState(() {
                            isFirst = (index == 0); 
                            isLast = (index == boarding.length - 1);
                          });                          
                        },
                        controller: boardController,
                        itemBuilder: (context, index) =>
                            OnBoardPageView(boarding[index]),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SmoothPageIndicator(
                      controller: boardController,
                      count: boarding.length,
                      effect: ExpandingDotsEffect(
                        dotWidth: 10.0,
                        radius: 16.0,
                        dotHeight: 12.0,
                        dotColor: Colors.grey[350]!,
                        strokeWidth: 10,
                        activeDotColor: fluentBlue,
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextButton(
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          splashFactory: NoSplash.splashFactory),
                      onPressed: () {
                        if (isLast) {
                          bloc.add(CacheOnBoardFirstTimeEvent(firstTime: false));
                        } 
                        else {
                          boardController.nextPage(
                              duration: const Duration(seconds: 2),
                              curve: Curves.fastLinearToSlowEaseIn);
                        }
                      },
                      child: Container(
                        width: 400.w,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: fluentNavy,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            isLast
                                ? "Create Account"
                                : "Next",
                            style: TextStyle(
                                color: fluentWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              
              },
            ),
          ),
        ),
      ));
  

    
  }
}