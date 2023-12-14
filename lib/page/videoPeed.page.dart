import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mootube_client/component/videoElement.component.dart';
import 'package:dio/dio.dart';
import '../component/appBar.component.dart';

class VideoPeedPage extends StatefulWidget {
  const VideoPeedPage({super.key});

  @override
  _VideoPeedState createState() => _VideoPeedState();
}

class _VideoPeedState extends State<VideoPeedPage> {
  List videoList = [];
  Dio dio = Dio();

  @override
  void initState() {
    fetchVideo().then((videoList) {
      if (mounted) {
        setState(() {
          this.videoList = videoList;
        });
      }
    });
    super.initState();
  }

  Future<void> refreshVideos() async {
    var res = await fetchVideo();
    setState(() {
      this.videoList = res;
    });
  }

  Future<dynamic> fetchVideo() async {
    var res = await dio.get("http://localhost:5678/video/videos");
    return res.data["videoList"];
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: SafeArea(
            child: Column(children: <Widget>[
      MooTubeAppBar(),
      Expanded(
        child: (videoList.isEmpty)
            ? Center(
                child: Container(
                    height: double.infinity,
                    child: Column(children: [
                      Text("준비된 영상이 없습니다.",
                          style: TextStyle(color: Colors.white)),
                      CupertinoButton(
                          child: Icon(
                            CupertinoIcons.refresh,
                            color: Colors.white,
                          ),
                          onPressed: refreshVideos)
                    ])))
            : CustomScrollView(slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: refreshVideos,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          VideoElement(videoInfo: videoList[index]),
                      childCount: videoList.length),
                )
              ]),
      )
    ])));
  }
}
