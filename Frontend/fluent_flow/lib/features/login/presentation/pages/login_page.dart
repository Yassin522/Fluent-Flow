import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_cubit.dart';
import 'package:fluent_flow/features/home/pages/home_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluent_flow/core/const/failure_messages.dart';
import 'package:fluent_flow/core/const/styles.dart';
import 'package:fluent_flow/core/widgets/loading_widget.dart';
import 'package:fluent_flow/features/register/presentation/pages/register_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/input_validation.dart';
import '../../../../core/utils/show_toast.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  static const String routeName = 'loginPage';

  late double height;
  late double width;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final loginFormKey = GlobalKey<FormState>();

  LoginPage({Key? key}) : super(key: key);

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
            child: Form(
              key: loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 714.w,
                    height: 850.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/logo_1.png",
                          width: width * 0.1,
                          height: width * 0.1,
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          height: 73.h,
                          width: 509.w,
                          child: TextFormField(
                            controller: emailController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.next,
                            onTap: () => Scrollable.ensureVisible(context),
                            keyboardType: TextInputType.emailAddress,
                            maxLines: 1,
                            validator: (value) {
                              if (!isNotEmptyField(value)) {
                                return emptyFieldMessage;
                              }
                              return null;
                            },
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                            decoration: InputDecoration(
                              hintText: "Email",
                              prefixIcon: Icon(
                                IconData(int.parse('0x${0040}')),
                                size: 22,
                                color: fluentNavy,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 73.h,
                          width: 509.w,
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            textInputAction: TextInputAction.next,
                            onTap: () => Scrollable.ensureVisible(context),
                            maxLines: 1,
                            validator: (value) {
                              if (!isNotEmptyField(value)) {
                                return emptyFieldMessage;
                              }
                              return null;
                            },
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                            decoration: InputDecoration(
                              hintText: "Password",
                              prefixIcon: Icon(
                                color: fluentNavy,
                                Icons.lock,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height*0.02,
                        ),
                        BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                            if (state is LoginLoadingState) {
                              return const LoadingWidget(
                                size: 26,
                                stroke: 4,
                              );
                            }
                            return Container(
                              height: 26,
                            );
                          },
                        ),
                        SizedBox(
                          height: height*0.02,
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              splashFactory: NoSplash.splashFactory),
                          onPressed: () {
                            if (loginFormKey.currentState!.validate()) {
                              BlocProvider.of<LoginBloc>(context)
                                  .add(GoLoginEvent(
                                email: emailController.text,
                                password: passwordController.text,
                              ));
                            }
                          },
                          child: Container(
                            width: 182.w,
                            height: 73.h,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: fluentBlue,
                              borderRadius: BorderRadius.circular(25.r),
                            ),
                            child: Center(
                              child: Text(
                                "Login",
                                maxLines: 1,
                                style: TextStyle(
                                    color: fluentWhite,
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: RichText(
                            textScaleFactor: 1.1,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'New  here  ',
                              style: TextStyle(
                                color: fluentNavy,
                                fontSize: 16,
                              ),
                              children: [
                                TextSpan(
                                  text: "Register Now",
                                  recognizer: TapGestureRecognizer()..onTap = () {
                                    Navigator.popAndPushNamed(context, RegisterPage.routeName);
                                  },
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 16,
                                    color: fluentNavy,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        BlocListener<LoginBloc, LoginState>(
                          listener: (context, state) {
                            if (state is LoginSuccessState) {
                              context.read<FluentCubit>().getLocalUser();
                              Navigator.popAndPushNamed(context, HomePage.routeName);
                            }
                            if (state is LoginErrorState) {
                              showToast(state.message, context, false);
                            }
                          },
                          child: Container(),
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
