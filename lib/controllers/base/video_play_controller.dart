import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayController extends StatefulWidget {
  String videopath;
   VideoPlayController({required this.videopath});

  @override
  State<VideoPlayController> createState() => _VideoPlayControllerState();
}

class _VideoPlayControllerState extends State<VideoPlayController> {
  late final VideoPlayerController _controller;
  late ChewieController _chewieController;
  bool _loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    File file = File(widget.videopath);
    _controller = VideoPlayerController.file(file)
      ..initialize().then((value) {
        // 加载完成
        // _controller.play();
        _loading = false;
        setState(() {});
      });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
    _chewieController = ChewieController(
      videoPlayerController: _controller,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  _loading
          ? Center(
        child: CircularProgressIndicator(),
      )
          :   Chewie(controller: _chewieController)
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.pause();
    _controller.dispose();
  }
}
