import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:io';
import 'package:spring_button/spring_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:videotrimandcut/constants/constants.dart';
import 'package:videotrimandcut/widgets/animated_buttons.dart';
import 'package:videotrimandcut/widgets/progress.dart';
import 'package:videotrimandcut/widgets/video_player_widget.dart';
import 'package:videotrimandcut/widgets/video_trimmer_widget.dart';

class UploadTrimmedCutVideo extends StatefulWidget {
  UploadTrimmedCutVideo({Key key}) : super(key: key);

  @override
  _UploadTrimmedCutVideoState createState() => _UploadTrimmedCutVideoState();
}

class _UploadTrimmedCutVideoState extends State<UploadTrimmedCutVideo> {
  final imagePicker = ImagePicker();
  Trimmer _trimmer = Trimmer();
  File _file;
  File _returnedFile;
  File _compressedFile;

  VideoPlayerController _videoPlayerController;
  bool contentTypeImage;

  @override
  void initState() {
    super.initState();
    contentTypeImage = false;
    _file = null;
    _returnedFile = null;
    _compressedFile = null;
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Scaffold buildUploadScreenn() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kRedLight,
        title: Text("Video Trim & Cut by AZ Ackmatoff"),
      ),
      body: Container(
        color: kGreyDarker,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: SvgPicture.asset(
                'assets/images/video.svg',
                height: 250.0,
              ),
            ),
            Expanded(
              flex: 1,
              child: SpringButton(
                SpringButtonType.OnlyScale,
                AnimatedButtonsWidget(
                  color: kPurple,
                  text: "Upload Video",
                ),
                onTapDown: (_) => _uploadFile(context, "video"),
              ),
            ),
            Expanded(
              flex: 1,
              child: SpringButton(
                SpringButtonType.OnlyScale,
                AnimatedButtonsWidget(
                  text: "Upload Image",
                  color: kRedLighter,
                ),
                onTapDown: (_) => _uploadFile(context, "image"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  clearUploadContent() {
    setState(() {
      _file = null;
      _videoPlayerController.pause();
      _returnedFile = null;
      _compressedFile = null;

      _videoPlayerController.dispose();
    });
  }

  Scaffold buildFileResultScreen() {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPurpleDark,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kWhite),
          onPressed: clearUploadContent,
        ),
        title: Text(
          "Video Result",
          style: TextStyle(color: kWhite),
        ),
        actions: [
          Container(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0),
//                  height: 10.0,
            child: GestureDetector(
              onTap: () => _dummyShareYourContent(context),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kWhite,
                    style: BorderStyle.solid,
                    width: 1.0,
                  ),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Center(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.send),
                            SizedBox(width: 5.0),
                            Text(
                              "SHARE",
                              style: TextStyle(
                                  color: kWhite,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          contentTypeImage == true
              ? Container(
                  height: 180.0,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Center(
                      child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(_file),
                        ),
                      ),
                    ),
                  )),
                )
              : VideoPlayerWidget(videoFile: _file),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          Center(
            child: Text(
              "SO, THIS IS THE END",
              style: TextStyle(color: kPurpleDark, fontSize: 22),
            ),
          ),
        ],
      ),
    );
  }

  _uploadFile(context, String fileType) {
    Alert(
      context: context,
      type: AlertType.none,
      title: "UPLOAD FROM",
      buttons: [
        DialogButton(
            child: Text(
              "CAMERA",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () => fileType == "video" ? handleTakeVideo() : null,
            color: kPurple),
        DialogButton(
          child: Text(
            "GALLERY",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () =>
              fileType == "video" ? handleChooseFromGalleryVideo() : null,
          color: kRedLight,
        )
      ],
    ).show();
  }

  _dummyShareYourContent(context) {
    Alert(
      context: context,
      type: AlertType.none,
      title: "WRITE TO YOUR DATABASE",
      desc: "From here on, you can take this video and write to your database",
      buttons: [
        DialogButton(
            child: Text(
              "CANCEL",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () => Navigator.pop(context),
            color: kPurple),
      ],
    ).show();
  }

  handleChooseFromGalleryVideo() async {
    Navigator.pop(context);
    final pickedFile = await imagePicker.getVideo(
      source: ImageSource.gallery,
    );

    File _fileToTrim = File(pickedFile.path);

    setState(() {
      _file = File(_fileToTrim.path);
    });

    if (_fileToTrim != null) {
      // await compressVideo();
      await _trimmer.loadVideo(videoFile: _file);

      String _trimmedPath = await Navigator.push(
          context,
          MaterialPageRoute<String>(
              fullscreenDialog: true,
              builder: (BuildContext context) {
                return TrimmerViewWidget(_trimmer);
              }));

      if (_trimmedPath == null) {
        setState(() {
          _file = null;
        });
      } else if (_file == null) {
        setState(() {
//          _videoPlayerController.dispose();
          _videoPlayerController.pause();
        });
      } else {
        setState(() {
          _returnedFile = File(_trimmedPath);
        });
      }
    }

    setState(() {
      _videoPlayerController = VideoPlayerController.file(_file)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
      // _videoPlayerController.play();
      _videoPlayerController.setLooping(false);
    });
  }

  handleTakeVideo() async {
    Navigator.pop(context);
    // From image_picker package
    // File from dart:io
    final pickedFile = await imagePicker.getVideo(
      source: ImageSource.camera,
    );

    File _fileToTrim = File(pickedFile.path);

    setState(() {
      _file = File(_fileToTrim.path);
    });

    if (_fileToTrim != null) {
      // await compressVideo();
      await _trimmer.loadVideo(videoFile: _file);

      String _trimmedPath = await Navigator.push(context,
          MaterialPageRoute<String>(builder: (BuildContext context) {
        return TrimmerViewWidget(_trimmer);
      }));

      if (_trimmedPath == null) {
        setState(() {
          _file = null;
        });
      } else {
        setState(() {
          _file = File(_trimmedPath);

          _trimmer = null;
        });
      }

      setState(() {
        _videoPlayerController = VideoPlayerController.file(_file)
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          });
        // _videoPlayerController.play();
        // _videoPlayerController.setVolume(0.1);
        _videoPlayerController.setLooping(false);
      });
    }
  }

  compressVideo() async {
    if (_file != null) {
      MediaInfo compressedVideoInfo = await VideoCompress.compressVideo(
        _file.path,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
      );
      setState(() {
        _compressedFile = compressedVideoInfo.file;
      });
      //return true;
    } else {
      //return true;
    }
  }

  buildingScreen() {
    if (_file == null) {
      return buildUploadScreenn();
    } else if (_returnedFile == null) {
      return Center(child: circularProgress());
    } else {
      return buildFileResultScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildingScreen();
  }
}
