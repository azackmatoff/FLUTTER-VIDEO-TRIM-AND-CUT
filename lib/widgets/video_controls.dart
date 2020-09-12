import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoControls extends StatefulWidget {
  const VideoControls({this.videoController});

  final VideoPlayerController videoController;

  @override
  _VideoControlsState createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    widget.videoController.addListener(_videoListener);
    widget.videoController.setLooping(false);

    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    widget.videoController?.removeListener(_videoListener);
    super.dispose();
  }

  void _videoListener() {
    (widget.videoController.value.isPlaying)
        ? _animationController.forward()
        : _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: const Color(0x40000000),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  iconSize: 30,
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.play_pause,
                    progress: _animationController,
                    color: Colors.white,
                  ),
                  onPressed: _handleOnPressed,
                ),
                Text(
                  '0:00',
                  style: TextStyle(color: Colors.white),
                ),
                Expanded(
                  child: VideoProgressIndicator(
                    widget.videoController,
                    allowScrubbing: true,
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    colors: VideoProgressColors(
                      playedColor: Colors.white,
                    ),
                  ),
                ),
                Text(
                  timeFormatter(widget.videoController.value.duration),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String timeFormatter(Duration duration) {
    return [
      if (duration.inHours != 0) duration.inHours,
      duration.inMinutes,
      duration.inSeconds,
    ].map((seg) => seg.remainder(60).toString().padLeft(2, '0')).join(':');
  }

  playItFromStartAgain() {
    widget.videoController.play();
    if (widget.videoController.value.position ==
        widget.videoController.value.buffered.last.end) {
      Duration duration;
      setState(() {
        duration = widget.videoController.value.buffered.last.start;
      });
      widget.videoController.seekTo(duration);
    } else {
      widget.videoController.play();
    }
  }

  void _handleOnPressed() {
    widget.videoController.value.isPlaying ? _pauseVideo() : _playVideo();
  }

  void _playVideo() {
    _animationController.forward();

    // widget.videoController.play();
    playItFromStartAgain();
  }

  void _pauseVideo() {
    _animationController.reverse();
    widget.videoController.pause();
  }
}
