import 'package:fluent_flow/core/cache/cache_helper.dart';
import 'package:fluent_flow/core/const/styles.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_cubit_observer.dart';
import 'package:fluent_flow/cubits/fluent_flow/fluent_flow_cubit.dart';
import 'package:fluent_flow/features/dashboard/pages/dashboard_page.dart';
import 'package:fluent_flow/features/evaluate_script/pages/evaluate_script_page.dart';
import 'package:fluent_flow/features/evaluate_script/pages/script_scores_page.dart';
import 'package:fluent_flow/features/home/pages/home_page.dart';
import 'package:fluent_flow/features/library/pages/library_page.dart';
import 'package:fluent_flow/features/profile/pages/change_password_page.dart';
import 'package:fluent_flow/features/suggested_scripts/pages/suggested_scripts_page.dart';
import 'package:fluent_flow/features/upload_video/pages/video_page.dart';
import 'package:fluent_flow/features/login/presentation/bloc/login_bloc.dart';
import 'package:fluent_flow/features/login/presentation/pages/login_page.dart';
import 'package:fluent_flow/features/onboarding/data/data_sources/onboard_local_data_source.dart';
import 'package:fluent_flow/features/onboarding/presentation/bloc/onboard_bloc.dart';
import 'package:fluent_flow/features/onboarding/presentation/pages/onboard_page.dart';
import 'package:fluent_flow/features/profile/pages/profile_page.dart';
import 'package:fluent_flow/features/register/presentation/blocs/register_bloc.dart';
import 'package:fluent_flow/features/register/presentation/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'get_it_init.dart' as getit;

Future<void> main() async {
  await getit.init();
  Bloc.observer = FluentObserver();
  CacheHelper cacheHelper = getit.getIt<CacheHelper>();
  bool? onBoarding = cacheHelper.getData(key: cachedOnBoardFirstTime);
  onBoarding ??= true;

  String? token = cacheHelper.getToken();
  String startPage = onBoarding ? OnBoardPage.routeName : token == null ? LoginPage.routeName : LoginPage.routeName;
  // put the current working screen rout here
  // startPage = HomePage.routeName;
  runApp(MyApp(startPage: startPage));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.startPage}) : super(key: key);

  final String startPage;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getit.getIt<FluentCubit>(),
        ),
        BlocProvider(
          create: (context) => getit.getIt<RegisterBloc>(),
        ),
        BlocProvider(
          create: (context) => getit.getIt<OnBoardBloc>(),
        ),
        BlocProvider(
          create: (context) => getit.getIt<LoginBloc>(),
        ),
      ],
      child: ScreenUtilInit( 
        designSize: const Size(1920 , 1080),
        minTextAdapt: true , 
        splitScreenMode: true, 
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Fluent Flow',
          theme: lightTheme,
          initialRoute: startPage,
          routes: {
            OnBoardPage.routeName: (context) => const OnBoardPage(),
            LoginPage.routeName: (context) => LoginPage(),
            RegisterPage.routeName: (context) => RegisterPage(),
            ProfilePage.routeName: (context) => ProfilePage(),
            HomePage.routeName: (context) => const HomePage(),
            DashboardPage.routeName: (context) => const DashboardPage(),
            LibraryPage.routeName: (context) => const LibraryPage(),
            VideoPage.routeName: (context) => const VideoPage(),
            ChangePasswordPage.routeName: (context) => const ChangePasswordPage(),
            SuggestedScriptsPage.routeName: (context) => const SuggestedScriptsPage(),
            EvaluateScriptsPage.routeName: (context) => const EvaluateScriptsPage(),
            ScriptScoresPage.routeName: (context) => const ScriptScoresPage(),
            // GesturesScorePage.routeName: (context) => const GesturesScorePage(),
            // VoiceScorePage.routeName: (context) => const VoiceScorePage(),
            // ScriptXScorePage.routeName: (context) => const ScriptXScorePage(),
          },
        ),
      ),
    );
  }
}
