import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_cubit.dart';
import 'package:fluent_flow/features/dashboard/pages/dashboard_page.dart';
import 'package:fluent_flow/features/home/pages/home_page.dart';
import 'package:fluent_flow/features/library/pages/library_page.dart';
import 'package:flutter/material.dart';
import 'package:fluent_flow/core/const/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:fluent_flow/features/home/presentation/pages/home_page.dart';
// import 'package:fluent_flow/features/Profile/presentation/pages/profile_page.dart';
// import 'package:fluent_flow/features/Settings/presentation/pages/settings_page.dart';

// ignore: must_be_immutable
class TabWidget extends StatelessWidget {

  final IconData icon;
  final String title;
  final bool selected;
  final int index;

  TabWidget({Key? key, required this.icon, required this.title, required this.selected, required this.index}) : super(key: key);

  late double height;
  late double width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        if(index == 2){
          FluentCubit.get(context).getScores();
        }
        if(index == 3){
          FluentCubit.get(context).getVideos();
        }
        (index == 1 && !selected)? Navigator.popAndPushNamed(context, HomePage.routeName)
        : (index == 2 && !selected)? Navigator.popAndPushNamed(context, DashboardPage.routeName)
        : (index == 3 && !selected)? Navigator.pushNamed(context, LibraryPage.routeName)
        : null;
      },
      child: Row(
        children: [          
          Expanded(
            flex:3,
            child: Icon(
              icon,
              color: selected? fluentLightPurple : fluentNavy,
              size: 50.sp,
            ),
          ),
          Expanded(
            flex:4,
            child: Text(
              title,
              maxLines: 1,
              style: TextStyle(
                color: selected? fluentLightPurple : fluentNavy,
                fontWeight: FontWeight.bold,
                fontSize: 30.sp
              ),
            ),
          )
        ],
      ),
    );
  }
}