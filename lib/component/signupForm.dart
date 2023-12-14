import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../util/Alert.dart';
import 'package:dio/dio.dart';

// import '../storage/TokenStorage.dart';

class SignupForm extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  SignupForm({super.key});

  bool isIdUnique = false;

  Future<void> isIdExist(userIdInput) async {
    var dio = Dio();

    if (userIdInput.trim().isEmpty) return;

    await dio.get('http://localhost:5678/user/id/exist',
        queryParameters: {"id": userIdInput}).then((response) {
      int responseStatus = response.data["result"];

      if (responseStatus == 0) {
        isIdUnique = true;
      } else if (responseStatus == 1) {
        isIdUnique = false;
      }
    });
  }

  void isValid(context, id, pw, name) {
    if (id.trim().isEmpty) {
      Alert.toast(context, "ID를 입력해주세요.");
      return;
    }
    if (pw.trim().isEmpty) {
      Alert.toast(context, "비밀번호를 입력해주세요.");
      return;
    }
    if (name.trim().isEmpty) {
      Alert.toast(context, "이름을 입력해주세요.");
      return;
    }
  }

  void requestSignup(BuildContext context) async {
    final String userIdInput = idController.text;
    final String userPwInput = pwController.text;
    final String userNameInput = nameController.text;

    isValid(context, userIdInput, userPwInput, userNameInput);

    await isIdExist(userIdInput);

    var dio = Dio();

    if (isIdUnique) {
      await dio.post('http://localhost:5678/user/register', data: {
        "id": userIdInput,
        "pw": userPwInput,
        "name": userNameInput
      }).then((response) {
        int responseStatus = response.data["result"];

        if (responseStatus == 0) {
          Navigator.popAndPushNamed(context, '/login');
        } else {
          Alert.toast(context, response.data["message"]);
        }
      });
    } else {
      Alert.toast(context, "이미 존재하는 ID입니다.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            "최소한의 정보로 MooTube의 회원이 되어보세요",
            style:
                TextStyle(color: Color.fromARGB(255, 76, 75, 75), fontSize: 20),
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 16),
        CupertinoTextField(
          controller: nameController,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          placeholder: 'Name',
          placeholderStyle: const TextStyle(
            color: CupertinoColors.systemGrey, // Placeholder의 색상을 지정
          ),
          style: const TextStyle(color: Colors.white),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 22, 27, 30), // 배경색 지정
            borderRadius: BorderRadius.circular(8.0),
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
              onPressed: () {
                requestSignup(context);
              },
              child: const Text(
                '가입하기',
                style: TextStyle(color: Colors.white),
              )),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: Row(
            children: [
              const Text(
                "계정이 이미 있으신가요?",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "로그인",
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
