import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mootube_client/service/checkToken.service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      checkToken(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text("MooTube",
            style: TextStyle(
                color: Colors.white, fontFamily: "Gugi", fontSize: 36)));
  }
}
