import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mootube_client/storage/TokenStorage.dart';

import '../component/loginForm.dart';
import '../util/Alert.dart';

class UploadPage extends StatelessWidget {
  String videoId;
  Dio dio = Dio();
  UploadPage({super.key, required this.videoId});
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();

  Future<void> requestUpdatingInfo(BuildContext context) async {
    String? token = await TokenStorage.getToken();
    String titleText = titleController.text;
    String descText = descController.text;

    if (!context.mounted) return;

    if (titleText.trim().isEmpty) {
      Alert.toast(context, "영상 제목을 입력해주세요.");
      return;
    }

    if (descText.trim().isEmpty) {
      Alert.toast(context, "영상 설명을 입력해주세요.");
      return;
    }

    dio.put("http://localhost:5678/video/$videoId/info",
        options: Options(headers: {"Authorization": token}),
        data: {"title": titleText, "desc": descText}).then((res) {
      if (res.data["result"] == 0) {
        Navigator.of(context).pop();
      } else {
        Alert.toast(context, "영상 업로드에 실패했습니다.");
      }
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: SafeArea(
      child: Container(
          padding: EdgeInsets.fromLTRB(12, 20, 12, 0),
          child: Column(children: [
            CupertinoTextField(
              controller: titleController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              placeholder: '제목',
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
            SizedBox(
              height: 16,
            ),
            CupertinoTextField(
              controller: descController,
              minLines: 10,
              maxLines: 10,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              placeholder: '영상 설명',
              placeholderStyle: const TextStyle(
                color: CupertinoColors.systemGrey, // Placeholder의 색상을 지정
              ),
              keyboardType: TextInputType.multiline,
              style: const TextStyle(color: Colors.white),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 22, 27, 30), // 배경색 지정
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                  color: const Color.fromARGB(255, 213, 89, 51),
                  onPressed: () {
                    requestUpdatingInfo(context);
                  },
                  child: const Text(
                    '영상 등록',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ])),
    ));
  }
}
