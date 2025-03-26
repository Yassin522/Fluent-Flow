import 'package:fluent_flow/core/const/job_titles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluent_flow/core/const/failure_messages.dart';
import 'package:fluent_flow/core/const/styles.dart';
import 'package:fluent_flow/core/widgets/loading_widget.dart';
import 'package:fluent_flow/features/login/presentation/pages/login_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/input_validation.dart';
import '../../../../core/utils/show_toast.dart';
import '../blocs/register_bloc.dart';

// ignore: must_be_immutable
class RegisterPage extends StatefulWidget {
  static const String routeName = 'register_page';

  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  late double height;

  late double width;

  TextEditingController nameController = TextEditingController();

  TextEditingController jobController = TextEditingController(text: 'teacher');

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  String jobTitle = 'public speaker';

  final registerFormKey = GlobalKey<FormState>();

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
            padding: const EdgeInsets.all(24),
            child: Form(
              key: registerFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 1449.w,
                    height: 850.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/welcome_1.png",
                              width: width * 0.2,
                              height: width * 0.1,
                            ),
                            SizedBox(width: width * 0.05),
                            Image.asset(
                              "assets/images/logo_1.png",
                              width: width * 0.1,
                              height: width * 0.1,
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: SizedBox(
                                width: 509.w,
                                height: 73.h,
                                child: TextFormField(
                                  controller: nameController,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  textInputAction: TextInputAction.next,
                                  onTap: () => Scrollable.ensureVisible(context),
                                  keyboardType: TextInputType.name,
                                  maxLines: 1,
                                  validator: (value) {
                                    if (validName(value)) {
                                      return null;
                                    } else if (!isNotEmptyField(value)) {
                                      return emptyFieldMessage;
                                    }
                                    return invalidNameMessage;
                                  },
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700),
                                  decoration: InputDecoration(
                                    hintText: "Name",
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: fluentNavy,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: width * 0.1),
                            Flexible(
                              child: SizedBox(
                                width: 509.w,
                                height: 73.h,
                                child: TextFormField(
                                  controller: emailController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  textInputAction: TextInputAction.next,
                                  onTap: () =>
                                      Scrollable.ensureVisible(context),
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
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: SizedBox(
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
                                    hintText: "Password",
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: fluentNavy,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: width * 0.1),
                            Flexible(
                                child: Container(
                                    width: 509.w,
                                    height: 73.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(25.r),
                                    ),
                                    child: DropdownButton<String>(
                                      underline: const SizedBox(),
                                      isExpanded: true,
                                      padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
                                      value: jobController.text,
                                      items: List.generate(
                                        job_titles.length,
                                        (index) => DropdownMenuItem(
                                          value: job_titles[index],
                                          child: Text(
                                            job_titles[index],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: fluentNavy
                                            ),
                                          ),
                                        ),
                                      ),
                                      onChanged: (String? value) {
                                        jobController.text = value ?? job_titles.first;
                                        setState(() {});
                                      },
                                    ))),
                          ],
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<RegisterBloc, RegisterState>(
                          builder: (context, state) {
                            if (state is RegisterLoadingState) {
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
                        SizedBox(height: height*0.02),
                        TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              splashFactory: NoSplash.splashFactory),
                          onPressed: () {
                            print("HI");
                            if (registerFormKey.currentState!.validate()) {
                              BlocProvider.of<RegisterBloc>(context).add(
                                  GoRegisterEvent(
                                      job: jobController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      name: nameController.text));
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
                                "Register",
                                maxLines: 1,
                                style: TextStyle(
                                    color: fluentWhite,
                                    fontSize: 27.sp,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height*0.04),
                        Center(
                          child: RichText(
                            textScaleFactor: 1.1,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Have  an  account?  ',
                              style: TextStyle(
                                color: fluentNavy,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                TextSpan(
                                  text: "Login",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.popAndPushNamed(
                                          context, LoginPage.routeName);
                                    },
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: fluentNavy,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocListener<RegisterBloc, RegisterState>(
                    listener: (context, state) {
                      if (state is RegisterDoneState) {
                        Future.delayed(const Duration(seconds: 0), () {
                          showToast(registerSuccessfully, context, false);
                        }).then((value) => Navigator.popAndPushNamed(
                            context, LoginPage.routeName));
                      }
                      if (state is RegisterErrorState) {
                        showToast(state.message, context, false);
                      }
                    },
                    child: Container(),
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
