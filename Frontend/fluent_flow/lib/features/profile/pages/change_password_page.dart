import 'package:fluent_flow/core/utils/show_toast.dart';
import 'package:fluent_flow/core/widgets/loading_widget.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_cubit.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_states.dart';
import 'package:flutter/material.dart';
import 'package:fluent_flow/core/const/failure_messages.dart';
import 'package:fluent_flow/core/const/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/input_validation.dart';

// ignore: must_be_immutable
class ChangePasswordPage extends StatefulWidget {
  static const String routeName = 'change_password_page';


  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late double height;

  late double width;

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  final profileFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    FluentCubit cubit = FluentCubit.get(context);
    emailController.text = cubit.user.email;
    super.initState();
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
            padding: const EdgeInsets.all(24),
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
                Container(
                  width: 1449.w,
                  height: 850.h,
                  padding: EdgeInsets.symmetric(horizontal: width*0.05),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/logo_1.png",
                            width: width * 0.1,
                            height: width * 0.1,
                          ),
                        ],
                      ),
                      Text(
                        "Change Your Password:",
                        maxLines: 1,
                        style: TextStyle(
                            color: fluentNavy,
                            fontSize: 40.sp,
                            fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: 509.w,
                        height: 73.h,
                        child: TextFormField(
                          controller: emailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.next,
                          readOnly: true,
                          onTap: () => Scrollable.ensureVisible(context),
                          keyboardType: TextInputType.emailAddress,
                          maxLines: 1,
                          validator: (value) {
                            if (!isNotEmptyField(value)) {
                              return emptyFieldMessage;
                            }
                            if (validEmail(value)) {
                              return null;
                            }
                            return invalidEmailMessage;
                          },
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700),
                          decoration: InputDecoration(
                              hintText: "Email",
                              prefixIcon: Icon(
                                IconData(int.parse('0x${0040}')),
                                color: fluentNavy,
                                size: 22,
                              )),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Form(
                        key: profileFormKey,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 509.w,
                              height: 73.h,
                              child: TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                textInputAction: TextInputAction.next,
                                onTap: () =>
                                    Scrollable.ensureVisible(context),
                                maxLines: 1,
                                validator: (value) {
                                  if (validPassword(value)) {
                                    return null;
                                  } else if (!isNotEmptyField(value)) {
                                    return emptyFieldMessage;
                                  }
                                  return invalidPasswordMessage;
                                },
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700),
                                decoration: InputDecoration(
                                  hintText: "New Password",
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: fluentNavy,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: 509.w,
                              height: 73.h,
                              child: TextFormField(
                                controller: confirmPasswordController,
                                obscureText: true,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                textInputAction: TextInputAction.next,
                                onTap: () =>
                                    Scrollable.ensureVisible(context),
                                maxLines: 1,
                                validator: (value) {
                                  if (validPassword(value)) {
                                    return null;
                                  } else if (!isNotEmptyField(value)) {
                                    return emptyFieldMessage;
                                  }
                                  return invalidPasswordMessage;
                                },
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700),
                                decoration: InputDecoration(
                                  hintText: "Confirm Password",
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: fluentNavy,
                                    size: 22,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height*0.05),
                      BlocConsumer<FluentCubit, FluentState>(
                        listener: (context, state) {
                          if(state is ChangePasswordSuccessState) {
                            showToast("Password Changed", context, false);
                            Navigator.pop(context);
                          } 
                          if(state is ChangePasswordErrorState) {
                            showToast(state.message, context, false);
                          }
                        },
                        builder: (context, state) => state is ChangePasswordLoadingState ? 
                        const Center(child: LoadingWidget(size: 26, stroke: 4)) : 
                        Center(
                          child: TextButton(
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                splashFactory: NoSplash.splashFactory),
                            onPressed: () {
                              if (profileFormKey.currentState!.validate()) {
                                if(passwordController.text == confirmPasswordController.text){
                                  FluentCubit.get(context).changePassword(passwordController.text);
                                } else {
                                  showToast("Passwords do not match. Please try again.", context, false);
                                }
                              }
                            },
                            child: Container(
                              width: 320.w,
                              height: 73.h,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: fluentWhite,
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Change Password",
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: fluentBlue,
                                          fontSize: 27.sp,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Icon(Icons.lock_rounded, color: fluentBlue)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
