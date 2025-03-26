import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_flow/core/const/api.dart';
import 'package:fluent_flow/core/const/job_titles.dart';
import 'package:fluent_flow/core/utils/show_toast.dart';
import 'package:fluent_flow/core/widgets/bubble_image.dart';
import 'package:fluent_flow/core/widgets/loading_widget.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_cubit.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_states.dart';
import 'package:fluent_flow/features/profile/pages/change_password_page.dart';
import 'package:flutter/material.dart';
import 'package:fluent_flow/core/const/failure_messages.dart';
import 'package:fluent_flow/core/const/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/input_validation.dart';

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  static const String routeName = 'profile_page';


  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late double height;

  late double width;

  TextEditingController emailController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController jobController = TextEditingController(text: 'teacher');

  final profileFormKey = GlobalKey<FormState>();

  bool editProfile = false;

  String? fileName;
  Uint8List? fileBytes;

  @override
  void initState() {
    FluentCubit cubit = FluentCubit.get(context);
    emailController.text = cubit.user.email;
    nameController.text = cubit.user.name;
    jobController.text = cubit.user.role;

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
            child: Form(
              key: profileFormKey,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                  width: 509.w,
                                  height: 73.h,
                                  child: TextFormField(
                                    controller: nameController,
                                    readOnly: !editProfile,
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
                                const SizedBox(height: 16),
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
                                editProfile ?
                                Container(
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
                                    ),
                                  ) : Container(
                                          width: 509.w,
                                          height: 73.h,
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(25.r),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.work_rounded,
                                                color: fluentNavy,
                                                size: 22,
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                jobController.text,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: fluentNavy,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                              ],
                            ),
                            BlocConsumer<FluentCubit, FluentState>(
                              listener: (context, state) {
                                if(state is AddPhotoErrorState){
                                  showToast(state.message, context, false);
                                }
                                if(state is AddPhotoSuccessState){
                                  showToast("Photo Uploaded Successfully", context, false);
                                }
                              },
                              builder: (context, state) {
                                FluentCubit cubit = FluentCubit.get(context);
                                return state is AddPhotoLoadingState ? 
                                const LoadingWidget(size: 26, stroke: 24) : 
                                BubbleImage(
                                  width: width, 
                                  height: height, 
                                  imageProvider: cubit.user.imageUrl == "imageUrl" ||
                                      cubit.user.imageUrl == null
                                  ? const AssetImage('assets/images/anime.jpg')
                                  : NetworkImage(IP_PORT + cubit.user.imageUrl!) as ImageProvider,
                                  edit: true,
                                  onEdit: () async {
                                    print("HI");
                                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                                      type: FileType.image,
                                      withData: true,
                                    );
                                    if (result != null) {
                                      fileName = result.files.single.name;
                                      fileBytes = result.files.single.bytes;
                                      cubit.addPhoto(fileName, fileBytes);
                                    }
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: height*0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            BlocConsumer<FluentCubit, FluentState>(
                              listener: (context, state) {
                                if(state is UpdateUserSuccessState){
                                  setState(() {
                                    editProfile = false;
                                  });
                                }
                                if(state is UpdateUserErrorState){
                                  showToast(state.message, context, false);
                                }
                              },
                              builder: (context, state) => state is UpdateUserLoadingState ? 
                              const Center(child: LoadingWidget(size: 26, stroke: 4)) : 
                              Center(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      splashFactory: NoSplash.splashFactory),
                                  onPressed: () {
                                    if(editProfile){
                                      FluentCubit.get(context).updateUser(nameController.text, jobController.text);
                                    } else {
                                      setState(() {
                                        editProfile = !editProfile;
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 220.w,
                                    height: 73.h,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: editProfile ? fluentWhite : fluentBlue,
                                      borderRadius: BorderRadius.circular(25.r),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            !editProfile ? "Edit Profile" : "Save Edit",
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: !editProfile ? fluentWhite : fluentBlue,
                                                fontSize: 27.sp,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Icon(Icons.edit, color: !editProfile ? fluentWhite : fluentBlue)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: width*0.01),
                            TextButton(
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  splashFactory: NoSplash.splashFactory),
                              onPressed: () {
                                Navigator.pushNamed(context, ChangePasswordPage.routeName);
                              },
                              child: Container(
                                width: 320.w,
                                height: 73.h,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: fluentBlue,
                                  borderRadius: BorderRadius.circular(25.r),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "change password",
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: fluentWhite,
                                            fontSize: 27.sp,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Icon(Icons.lock_rounded, color: fluentWhite)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
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

