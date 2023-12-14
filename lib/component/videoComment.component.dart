import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mootube_client/component/commentElement.component.dart';
import 'package:mootube_client/storage/TokenStorage.dart';

import '../util/Alert.dart';

class VideoComment extends StatefulWidget {
  final int videoId;
  const VideoComment({super.key, required this.videoId});

  @override
  _VideoCommentState createState() => _VideoCommentState();
}

class _VideoCommentState extends State<VideoComment> {
  TextEditingController commentController = TextEditingController();
  Dio dio = Dio();
  List commentList = [];

  @override
  void initState() {
    super.initState();
    _loadComment();
  }

  Future<void> _loadComment() async {
    String? token = await TokenStorage.getToken();
    await dio
        .get("http://localhost:5678/comment/${widget.videoId}",
            options: Options(headers: {"Authorization": token}))
        .then((res) {
      setState(() {
        commentList = res.data["commentList"];
      });
    });
  }

  Future<void> _postComment() async {
    String? token = await TokenStorage.getToken();
    String commentText = commentController.text;

    if (!context.mounted) return;

    if (commentText.trim().isEmpty) {
      Alert.toast(context, "댓글을 입력해주세요.");
      return;
    }

    await dio.post("http://localhost:5678/comment",
        options: Options(headers: {"Authorization": token}),
        data: {
          "video_id": widget.videoId,
          "comment": commentController.text
        }).then((res) async {
      commentController.text = "";
      await _loadComment();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(children: [
          Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 22, 27, 30),
                  borderRadius: BorderRadius.circular(8.0)),
              padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
              child: Row(
                children: [
                  Expanded(
                      flex: 16,
                      child: CupertinoTextField(
                        controller: commentController,
                        placeholder: '입력',
                        placeholderStyle: const TextStyle(
                          color:
                              CupertinoColors.systemGrey, // Placeholder의 색상을 지정
                        ),
                        style: TextStyle(color: Colors.white),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(0, 0, 0, 0),
                        ),
                      )),
                  Expanded(
                    flex: 2,
                    child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: _postComment,
                        child: Icon(CupertinoIcons.paperplane,
                            color: Colors.white)),
                  )
                ],
              )),
          Expanded(
            child: CustomScrollView(slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: _loadComment,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        CommentElement(commentInfo: commentList[index]),
                    childCount: commentList.length),
              )
            ]),
          )
        ]));
  }
}
