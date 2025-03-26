import 'package:fluent_flow/core/const/styles.dart';
import 'package:fluent_flow/features/login/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.popAndPushNamed(context, LoginPage.routeName);
      },
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(Icons.logout, color: fluentBlue, size: 30.sp),
          const SizedBox(width: 10),
          Text(
            "Logout",
            maxLines: 1,
            style: TextStyle(
                color: fluentBlue,
                fontSize: 30.sp,
                fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
