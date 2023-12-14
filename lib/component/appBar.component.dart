import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mootube_client/page/uploadPage.dart';
import 'package:mootube_client/storage/TokenStorage.dart';

import '../page/loginPage.dart';
import '../util/Alert.dart';

class MooTubeAppBar extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();
  Dio dio = Dio();

  Future pickVideo(context) async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    String? token = await TokenStorage.getToken();

    if (video != null) {
      var formData =
          FormData.fromMap({"file": await MultipartFile.fromFile(video.path)});
      try {
        var res = await dio.post('http://localhost:5678/video/upload',
            options: Options(headers: {"Authorization": token}),
            data: formData);

        if (res.statusCode == 200) {
          String videoId = res.data["video_id"];
          showCupertinoModalPopup(
              context: context,
              builder: (context) => UploadPage(
                    videoId: videoId,
                  ));
        }
      } catch (e) {
        Alert.toast(context, "업로드에 실패하였습니다.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Container(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'MooTube',
            style: TextStyle(
                fontFamily: 'Gugi', fontSize: 28, color: Colors.white),
          ),
          Row(
            children: [
              CupertinoButton(
                  onPressed: () {
                    pickVideo(context);
                  },
                  child: const Icon(CupertinoIcons.add, color: Colors.white)),
              CupertinoButton(
                  onPressed: () {},
                  child:
                      const Icon(CupertinoIcons.search, color: Colors.white)),
              CupertinoButton(
                  onPressed: () async {
                    await TokenStorage.deleteToken();
                    if (!context.mounted) return;
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            LoginPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.0, -1.0), // 위에서 시작
                                end: Offset.zero, // 아래로 이동
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: const Icon(CupertinoIcons.person, color: Colors.white))
            ],
          )
        ],
      ),
    ));
  }
}
