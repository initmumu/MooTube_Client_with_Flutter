import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mootube_client/page/video.page.dart';
import 'package:video_player/video_player.dart';

import '../util/timeAgo.dart';

class VideoElement extends StatelessWidget {
  final Map videoInfo;
  const VideoElement({super.key, required this.videoInfo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showCupertinoModalPopup(
              context: context,
              builder: (context) =>
                  VideoPlayerScreen(videoId: videoInfo["videoId"]));
        },
        child: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Column(
              children: <Widget>[
                Image.network(
                    "http://localhost:5678/${videoInfo['videoId']}/encoded/${videoInfo['videoId']}.gif"),
                Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(CupertinoIcons.person,
                            color: Colors.white,
                            size: MediaQuery.of(context).size.height * 0.04),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(this.videoInfo["title"],
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                              Text(
                                  "${videoInfo['publisher_name']}  ·  조회수 ${videoInfo['hits']}회  ·  ${timeAgo(DateTime.parse(videoInfo['publishDate']))} 전",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(114, 113, 113, 1)))
                            ],
                          ),
                        ),
                      ],
                    ))
              ],
            )));
  }
}
