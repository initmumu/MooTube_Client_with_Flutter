import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mootube_client/page/video.page.dart';
import 'package:video_player/video_player.dart';

import '../util/timeAgo.dart';

class CommentElement extends StatelessWidget {
  final Map commentInfo;
  const CommentElement({super.key, required this.commentInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Column(
        children: [
          Row(
            children: [
              Icon(CupertinoIcons.person,
                  color: Colors.white,
                  size: MediaQuery.of(context).size.height * 0.03),
              SizedBox(width: 8),
              Text(
                commentInfo['publisher_name'],
                style:
                    TextStyle(color: CupertinoColors.systemGrey, fontSize: 16),
              ),
              SizedBox(width: 6),
              Text(
                  "· ${timeAgo(DateTime.parse(commentInfo['publish_date']))} 전",
                  style: TextStyle(
                    color: CupertinoColors.systemGrey,
                  ))
            ],
          ),
          Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
              child: Text(
                commentInfo["body"],
                style: TextStyle(color: Colors.white, fontSize: 16),
              ))
        ],
      ),
    );
  }
}
