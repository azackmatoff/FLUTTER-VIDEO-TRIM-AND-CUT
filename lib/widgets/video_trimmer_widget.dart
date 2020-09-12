import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:video_trimmer/trim_editor.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:video_trimmer/video_viewer.dart';
import 'package:videotrimandcut/constants/constants.dart';

class TrimmerViewWidget extends StatefulWidget {
  final Trimmer _trimmer;
  TrimmerViewWidget(this._trimmer);
  @override
  _TrimmerViewWidgetState createState() => _TrimmerViewWidgetState();
}

class _TrimmerViewWidgetState extends State<TrimmerViewWidget> {
  double _startValue = 0.0;
  double _endValue = 10000.1;

  double onChangeStartValue;
  double onEndValue;
  double maxTrimDurationValue = 10000.2;

  bool _isPlaying = false;
  bool _progressVisibility = false;

  @override
  void initState() {
//   onEndValue - onChangeStartValue = 16000.20;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    String _value;

    await widget._trimmer
        .saveTrimmedVideo(startValue: _startValue, endValue: _endValue)
        .then((value) {
      if (mounted) {
        setState(() {
          _progressVisibility = false;
          _value = value;
        });
        print("_saveVideo value: " + _value);
      }
    });

    return _value;
  }

  void _warningDialog() {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "WARNING!",
      desc: "Video length can't be longer than 10 seconds!",
      alertAnimation: fadeAlertAnimation,
      buttons: [
        DialogButton(
          child: Text(
            "CLOSE",
            style: TextStyle(color: kWhite, fontSize: 18),
          ),
          onPressed: () => Navigator.pop(context),
          color: kRedLight,
        ),
      ],
    ).show();
  }

  Widget fadeAlertAnimation(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return Align(
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  _checkEndValue() {
    if (_endValue - _startValue > 10000.0) {
      _warningDialog();
    } else if (_endValue - _startValue < 10000.0) {
      _saveVideo().then((outputPath) async {
        Navigator.pop(context, outputPath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video trim"),
        backgroundColor: kPurple,
      ),
      body: Builder(
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Visibility(
                  visible: _progressVisibility,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
                Column(
                  children: <Widget>[
                    Center(
                      child: TrimEditor(
                        viewerHeight: 50.0,
                        viewerWidth: MediaQuery.of(context).size.width,
                        onChangeStart: (value) {
                          setState(() {
                            _startValue = value;
                          });

                          print("startValue: " + _startValue.toString());
                        },
                        onChangeEnd: (value) {
                          setState(() {
                            _endValue = value;
                          });

                          print("_endValue: " + _endValue.toString());
                        },
                        onChangePlaybackState: (value) {
                          setState(() {
                            _isPlaying = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    "MAXIMUM VIDEO LENGTH: 10 SECONDS",
                    style: TextStyle(color: kWhite),
                  ),
                ),
                Expanded(
                  child: VideoViewer(),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  color: kPurpleDark,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(width: 20.0),
                      FlatButton(
                        child: _isPlaying
                            ? Icon(
                                Icons.pause,
                                size: 60.0,
                                color: kWhite,
                              )
                            : Icon(
                                Icons.play_arrow,
                                size: 60.0,
                                color: kWhite,
                              ),
                        onPressed: () async {
                          bool playbackState =
                              await widget._trimmer.videPlaybackControl(
                            startValue: _startValue,
                            endValue: _endValue,
                          );
                          setState(() {
                            _isPlaying = playbackState;
                          });
                        },
                      ),
                      SizedBox(width: 40.0),
                      GestureDetector(
                        onTap: _progressVisibility
                            ? null
                            : () {
                                _checkEndValue();
                              },
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 10.0, right: 55.0, left: 55.0),
                          decoration: BoxDecoration(
                            color: kPurpleLight,
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(5.0)),
                          ),
                          child: Center(
                            child: Text(
                              "SAVE",
                              style: const TextStyle(
                                color: kWhite,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // RaisedButton(
                      //   onPressed: _progressVisibility
                      //       ? null
                      //       : () {
                      //           _checkEndValue();
                      //         },
                      //   child: Text(
                      //     "Save",
                      //     style: TextStyle(fontSize: 16.0),
                      //   ),
                      // ),
                      SizedBox(width: 40.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
