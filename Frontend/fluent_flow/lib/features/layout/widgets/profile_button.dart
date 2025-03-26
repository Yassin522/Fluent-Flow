import 'package:fluent_flow/core/const/api.dart';
import 'package:fluent_flow/core/const/styles.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_cubit.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_states.dart';
import 'package:fluent_flow/features/profile/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, ProfilePage.routeName);
      },
      child: BlocConsumer<FluentCubit, FluentState>(
        listener: (context, state) {},
        builder: (context, state) {
          FluentCubit cubit = FluentCubit.get(context);
          return Row(
            children: [
              CircleAvatar(
                radius: 30.w,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 26.w,
                  backgroundColor: fluentNavy,
                  foregroundImage: cubit.user.imageUrl == "imageUrl" ||
                          cubit.user.imageUrl == null
                      ? const AssetImage('assets/images/anime.jpg')
                      : NetworkImage(IP_PORT + cubit.user.imageUrl!) as ImageProvider,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    cubit.user.name,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    cubit.user.role,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
