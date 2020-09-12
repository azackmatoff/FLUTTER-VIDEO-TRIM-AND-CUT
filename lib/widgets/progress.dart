import 'package:flutter/material.dart';
import 'package:videotrimandcut/constants/constants.dart';

Container circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 10.0),
    child: CircularProgressIndicator(
      backgroundColor: kPurpleLight,
      valueColor: AlwaysStoppedAnimation(kRedLight),
    ),
  );
}

Container linearProgress() {
  return Container(
    padding: EdgeInsets.only(bottom: 10.0),
    child: LinearProgressIndicator(
      backgroundColor: kPurpleLight,
      valueColor: AlwaysStoppedAnimation(kRedLight),
    ),
  );
}
