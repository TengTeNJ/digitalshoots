import 'dart:io';

import 'package:robot/controllers/base/base_view_controller.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoPlayController extends StatefulWidget {
  String videopath;
   VideoPlayController({required this.videopath});

  @override
  State<VideoPlayController> createState() => _VideoPlayControllerState();
}

class _VideoPlayControllerState extends State<VideoPlayController> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videopath));
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              VideoPlayer(_controller),
              VideoProgressIndicator(_controller, allowScrubbing: true),
            ],
          ),
        ),
      )
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
