import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:mootube_client/page/videoPeed.page.dart';
import 'package:mootube_client/page/LoginPage.dart';
import '../storage/TokenStorage.dart';

Future<void> checkToken(BuildContext context) async {
  var dio = Dio();
  final token = await TokenStorage.getToken();
  if (!context.mounted) return;
  if (token != null && token.isNotEmpty) {
    try {
      await dio
          .get(
        'http://localhost:5678/user/auth/token',
        options: Options(headers: {
          'Authorization': '$token',
          // 다른 헤더 설정 가능
        }),
      )
          .then((response) {
        if (response.data["result"] == 0) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (context) => VideoPeedPage()),
          );
        }
      });
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => LoginPage()),
      );
    }
  } else {
    Navigator.pushReplacementNamed(context, '/login');
  }
}
