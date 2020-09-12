import 'package:flutter/material.dart';

class AnimatedButtonsWidget extends StatelessWidget {
  final Color color;
  final String text;
  final Function onTap;
  const AnimatedButtonsWidget({Key key, this.color, this.text, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding:
            EdgeInsets.only(top: 10.0, bottom: 10.0, right: 15.0, left: 15.0),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(const Radius.circular(5.0)),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
