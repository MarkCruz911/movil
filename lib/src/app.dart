import 'package:bus_client/src/routes/routes.dart';
import 'package:flutter/material.dart';


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MyThemes.lightTheme,
      initialRoute: Routes.initialRoute,
      routes: Routes.routes,
    );
  }
}


enum MyThemeKeys { LIGHT, DARK }

class MyThemes {

  static final ThemeData lightTheme = ThemeData(
    primaryColor: Color(0xff171d49),
    appBarTheme: AppBarTheme(color: Color(0xff171d49),),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: Colors.grey,
      cursorColor: Color(0xff171d49),
      selectionHandleColor: Color(0xff005e91),
    ),
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    highlightColor: Colors.white,
    floatingActionButtonTheme:
    FloatingActionButtonThemeData (backgroundColor: Colors.blue,focusColor: Colors.blueAccent , splashColor: Colors.lightBlue),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),

  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.grey,
    brightness: Brightness.dark,
    highlightColor: Colors.white,
    backgroundColor: Colors.black54,
    textSelectionTheme: TextSelectionThemeData(selectionColor: Colors.grey),
  );

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.LIGHT:
        return lightTheme;
      case MyThemeKeys.DARK:
        return darkTheme;
      default:
        return lightTheme;
    }
  }
}