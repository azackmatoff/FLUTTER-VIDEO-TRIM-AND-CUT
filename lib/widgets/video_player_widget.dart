import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:videotrimandcut/widgets/progress.dart';
import 'package:videotrimandcut/widgets/video_controls.dart';

// ignore: must_be_immutable
class VideoPlayerWidget extends StatefulWidget {
  final File videoFile;

  VideoPlayerWidget({this.videoFile});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  VideoPlayerController _controller;
//  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then(
        (_) {
          setState(() {});
        },
      );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (_controller.value.initialized) {
      return Stack(
        children: <Widget>[
          ClipRect(
            child: Container(
              child: _controller.value.aspectRatio < 1 / 1
                  ? Transform.scale(
                      scale: _controller.value.aspectRatio / size.aspectRatio,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(right: 100.0, left: 100.0),
                        child: Center(
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: VideoControls(
              videoController: _controller,
            ),
          ),
        ],
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 140.0),
        child: circularProgress(),
      );
    }
  }
}
