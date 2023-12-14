import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:mootube_client/page/splash.page.dart';
import 'package:mootube_client/page/videoPeed.page.dart';

import 'page/loginPage.dart';
import 'page/signupPage.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Color.fromARGB(255, 16, 19, 21)),
      title: 'MooTube',
      initialRoute: '/',
      routes: {
        "/": (BuildContext context) => SplashPage(),
        "/signup": (BuildContext context) => SignupPage(),
        "/login": (BuildContext context) => const LoginPage(),
        "/video/peed": (BuildContext context) => VideoPeedPage(),
      },
    );
  }
}
