import 'package:flutter/material.dart';

class Dot extends StatelessWidget {
  double _opacity;
  bool isVisible;

  Dot(this.isVisible) {
    _opacity = isVisible ? 1.0 : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _opacity,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.black,
        ),
      ),
    );
  }
}
