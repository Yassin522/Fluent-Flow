import 'package:fluent_flow/core/const/styles.dart';
import 'package:fluent_flow/core/widgets/tab_widget.dart';
import 'package:fluent_flow/features/layout/pages/layout.dart';
import 'package:fluent_flow/features/layout/widgets/logout_button.dart';
import 'package:fluent_flow/features/layout/widgets/profile_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SideBar extends StatelessWidget {
  const SideBar({
    super.key,
    required this.widget,
  });

  final HomeLayout widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width * 0.2,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black54.withOpacity(0.17), blurRadius: 14, spreadRadius: 9)
        ]
      ),
      child: Container(
        height: widget.height,
        width: widget.width * 0.2,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Image.asset(
                "assets/images/logo_1.png",
                width: 250.w,
                height: 130.h,
              ),
            ),
            Container(
              height: widget.height*0.3,
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TabWidget(icon: Icons.home_rounded, title: "Home", selected: widget.index == 1, index: 1),
                  TabWidget(icon: Icons.dashboard_rounded, title: "Dashboard", selected: widget.index == 2, index: 2),
                  TabWidget(icon: Icons.library_add_check_outlined, title: "Library", selected: widget.index == 3, index: 3),
                ],
              ),
            ),
            Container(
              height: 270.h,
              padding: const EdgeInsets.all(30),
              color: fluentLighterPurple,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ProfileButton(),
                  LogoutButton()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}