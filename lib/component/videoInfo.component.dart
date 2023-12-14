import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../storage/TokenStorage.dart';
import '../util/timeAgo.dart';

class VideoInfo extends StatefulWidget {
  final int videoId;
  const VideoInfo({super.key, required this.videoId});

  @override
  _VideoInfoState createState() => _VideoInfoState();
}

class _VideoInfoState extends State<VideoInfo> {
  Map videoInfo = {};
  bool _isLoading = false;
  bool _isDetail = false;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    String? token = await TokenStorage.getToken();
    if (token != null) {
      _dio
          .get(
        'http://localhost:5678/video/${widget.videoId}/info',
        options: Options(headers: {
          'Authorization': token,
        }),
      )
          .then((res) {
        setState(() {
          _isLoading = true;
          videoInfo = res.data["videoInfo"];
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.fromLTRB(14, 20, 14, 0),
        child: _isLoading
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    videoInfo["title"],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                          "조회수 ${videoInfo['hits']}회  ${timeAgo(DateTime.parse(videoInfo['publishDate']))} 전",
                          style: TextStyle(
                              color: Color.fromRGBO(114, 113, 113, 1),
                              fontSize: 16)),
                      CupertinoButton(
                          padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                          onPressed: () {
                            setState(() {
                              _isDetail = _isDetail ? false : true;
                            });
                          },
                          child: Text("더 보기",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)))
                    ],
                  ),
                  _isDetail & _isLoading
                      ? Container(
                          child: Text(videoInfo["desc"],
                              style: TextStyle(color: Colors.white)),
                        )
                      : Container(),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(CupertinoIcons.person,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.height * 0.03),
                      const SizedBox(width: 12),
                      Text(
                        "${videoInfo["publisher_name"]}",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              )
            : CircularProgressIndicator());
  }
}
