import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:mootube_client/page/videoPeed.page.dart';
import 'package:mootube_client/service/checkToken.service.dart';

import 'dart:async';
import '../storage/TokenStorage.dart';

import '../util/Alert.dart';

import "dart:convert";
import 'package:http/http.dart' as http;

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _greetMsg = 'Hola';
  final List<String> _greetMsgList = [
    'Hola',
    'Hello',
    '안녕하세요',
    'Bonjour',
  ];
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer =
        Timer.periodic(const Duration(seconds: 3), (Timer t) => _changeGreet());
  }

  void _changeGreet() {
    setState(() {
      _index = (_index + 1) % _greetMsgList.length;
      _greetMsg = _greetMsgList[_index];
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  Future<void> requestLogin() async {
    String userIdInput = idController.text;
    String userPwInput = pwController.text;

    if (userIdInput.trim().isEmpty) {
      Alert.toast(context, "아이디를 입력해주세요.");
      return;
    }

    if (userPwInput.trim().isEmpty) {
      Alert.toast(context, "비밀번호를 입력해주세요.");
      return;
    }
    var dio = Dio();

    await dio.post('http://localhost:5678/user/join',
        data: {"id": userIdInput, "pw": userPwInput}).then((response) async {
      int responseStatus = response.data["result"];
      /*
        0: 성공
        1: 로그인 정보가 존재하지 않음
      */
      String token =
          (responseStatus == 0) ? response.data["token"] : "loginFail";

      if (responseStatus == 1) {
        Alert.toast(context, "로그인 정보가 일치하지 않습니다.");
        return;
      }

      await TokenStorage.saveToken(token);

      if (!mounted) return; // 아직 위젯 트리에 해당 컨텍스트가 마운트되어 있는가?

      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => const VideoPeedPage()),
      );
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: SizedBox(
              width: double.infinity,
              // height: MediaQuery.of(context).size.height * ,
              key: ValueKey<String>(_greetMsg),
              child: Text(
                _greetMsg,
                // Provide a Key to the text widget, so AnimatedSwitcher knows when to animate.
                style: const TextStyle(
                    fontSize: 64,
                    color: Colors.white,
                    fontFamily: 'NanumPenScript',
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            "로그인하여 수 많은 영상 컨텐츠를 접해보세요",
            style:
                TextStyle(color: Color.fromARGB(255, 85, 83, 83), fontSize: 18),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 16),
        CupertinoTextField(
          controller: idController,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          placeholder: 'ID',
          placeholderStyle: const TextStyle(
            color: CupertinoColors.systemGrey, // Placeholder의 색상을 지정
          ),
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.white),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 22, 27, 30), // 배경색 지정
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        const SizedBox(height: 20),
        CupertinoTextField(
          controller: pwController,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          placeholder: 'Password',
          placeholderStyle: const TextStyle(
            color: CupertinoColors.systemGrey, // Placeholder의 색상을 지정
          ),
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 22, 27, 30), // 배경색 지정
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity, // 너비 지정
          height: 50, // 높이 지정
          child: CupertinoButton(
              color: const Color.fromARGB(255, 213, 89, 51),
              onPressed: requestLogin,
              child: const Text(
                '로그인',
                style: TextStyle(color: Colors.white),
              )),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: Row(
            children: [
              const Text(
                "계정이 없으신가요?",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text(
                  "가입하기",
                  style: TextStyle(
                      color: Color.fromARGB(255, 213, 89, 51), fontSize: 16),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
