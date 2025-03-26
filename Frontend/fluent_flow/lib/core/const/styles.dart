import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const begin = Offset(1.0, 0.0);
const end = Offset(0.0, 0.0);
const curve = Curves.ease;
var fluentTween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

Gradient backgroundGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [const Color(0xFF61ABFA).withOpacity(0.6), const Color(0xFFBBB8F5).withOpacity(0.6)],
);

Color fluentPurple = const Color(0xFF6C4AB6);
Color fluentLightPurple = const Color(0xFF9090FF);
Color fluentLighterPurple = const Color(0xFFEFEFFF);
Color fluentNavy = const Color(0xFF28285B);
Color fluentBlue = const Color(0xFF00A0FA);
Color fluentLightBlue = const Color(0xFF98E0F3);
Color fluentWhite = Colors.white;
Color fluentRed = Colors.red;

Map<int, Color> getSwatch(Color color) {
  return {
     50:color,
    100:color,
    200:color,
    300:color,
    400:color,
    500:color,
    600:color,
    700:color,
    800:color,
    900:color,
  };
}

InputDecorationTheme fluentInputDecoration = InputDecorationTheme(

  filled: true,
  fillColor: fluentWhite,

  hintStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: fluentNavy,
    fontSize: 16
  ),

  errorStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: fluentRed,
    fontSize: 12
  ),

  contentPadding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 10,
  ),
  
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.r),
    borderSide: BorderSide(
      width: 1.0,
      color: fluentWhite,
    ),
  ),

  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.r),
    borderSide: BorderSide(
      width: 1.0,
      color: fluentNavy,
    ),
  ),

  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.r),
    borderSide: BorderSide(
      width: 1.0,
      color: fluentRed,
    ),
  ),

  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.r),
    borderSide: BorderSide(
      width: 1.0,
      color: fluentRed,
    ),
  ),
);

InputDecorationTheme darkInputDecoration = InputDecorationTheme(

  filled: true,
  fillColor: fluentNavy,

  hintStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: fluentNavy,
    fontSize: 16
  ),

  errorStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: fluentRed,
    fontSize: 12
  ),

  contentPadding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 10,
  ),
  
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.r),
    borderSide: BorderSide(
      width: 1.0,
      color: fluentNavy,
    ),
  ),

  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.r),
    borderSide: BorderSide(
      width: 1.0,
      color: fluentNavy,
    ),
  ),

  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.r),
    borderSide: const BorderSide(
      width: 1.0,
    ),
  ),

  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.r),
    borderSide: const BorderSide(
      width: 1.0,
    ),
  ),
);

InputDecoration addSectionInputDecoration = InputDecoration(

  filled: true,
  fillColor: fluentNavy.withOpacity(0.3),

  hintStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: fluentNavy,
    fontSize: 16
  ),

  errorStyle: TextStyle(
    fontStyle: FontStyle.normal,
    color: fluentRed,
    fontSize: 12
  ),

  contentPadding: const EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 4,
  ),
  
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.r),
    borderSide: BorderSide(
      width: 1.0,
      color: fluentNavy.withOpacity(0),
    ),
  ),

  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.r),
    borderSide: BorderSide(
      width: 1.0,
      color: fluentNavy.withOpacity(0),
    ),
  ),

  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.r),
    borderSide: BorderSide(
      width: 1.0,
      color: fluentRed,
    ),
  ),

  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(25.r),
    borderSide: BorderSide(
      width: 1.0,
      color: fluentRed,
    ),
  ),
);

ThemeData lightTheme = ThemeData(
  fontFamily: 'Quicksand',
  inputDecorationTheme: fluentInputDecoration,
  iconTheme: IconThemeData(color: fluentNavy), 
  primarySwatch: MaterialColor(fluentLightPurple.value, getSwatch(fluentLightPurple)),
  primaryColor: fluentBlue,
  brightness: Brightness.light,
  scaffoldBackgroundColor: fluentWhite,
  dividerColor: fluentNavy,
  listTileTheme: ListTileThemeData(
    textColor: fluentNavy,
  ),  
),

darkTheme = ThemeData(
  fontFamily: 'Quicksand',
  inputDecorationTheme: darkInputDecoration,
  iconTheme: IconThemeData(color: fluentNavy), 
  primarySwatch: MaterialColor(fluentBlue.value, getSwatch(fluentBlue)),
  primaryColor: fluentWhite,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF212121),
  dividerColor: fluentNavy,
);