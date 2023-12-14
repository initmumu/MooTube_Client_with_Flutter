import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:mootube_client/component/videoComment.component.dart';
import 'package:mootube_client/component/videoInfo.component.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final int videoId;
  const VideoPlayerScreen({super.key, required this.videoId});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  AnimationController? _controller;
  double _dragOffset = 0.0;
  Map videoInfo = {};

  @override
  void initState() {
    var dio = Dio();
    dio.put("http://localhost:5678/video/hits/increase",
        data: {"videoId": widget.videoId});
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(microseconds: 1000));
    _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse('http://localhost:5678/video/${widget.videoId}'));

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: false,
      placeholder: Container(
        color: Colors.grey,
      ),
      autoInitialize: true,
      allowFullScreen: true,
      fullScreenByDefault: false,
    );
  }

  void _onDragEnd(DragEndDetails details) {
    _controller!.addListener(() {
      setState(() {
        _dragOffset = _controller!.value * MediaQuery.of(context).size.height;
      });
    });
    _controller!
        .reverse(from: _dragOffset / MediaQuery.of(context).size.height);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 16, 19, 21),
        body: Transform.translate(
          offset: Offset(0, _dragOffset),
          child: SafeArea(
            minimum: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(
              children: [
                GestureDetector(
                  onVerticalDragUpdate: (details) {
                    setState(() {
                      _dragOffset += details.delta.dy;
                    });

                    if (details.primaryDelta! > 50) {
                      Navigator.of(context).pop();
                    }
                  },
                  onVerticalDragEnd: _onDragEnd,
                  child: SizedBox(
                      height: MediaQuery.of(context).size.width * 9 / 16,
                      child: Chewie(
                        controller: _chewieController,
                      )),
                ),
                VideoInfo(videoId: widget.videoId),
                Expanded(child: VideoComment(videoId: widget.videoId)),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    _controller?.dispose();
    super.dispose();
  }
}
