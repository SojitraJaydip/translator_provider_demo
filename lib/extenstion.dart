import 'package:flutter/material.dart';

extension WidgetModifier on Widget {
  Widget padding(double value) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }

  Widget paddingOnly({
    double right = 0,
    double left = 0,
    double top = 0,
    double bottom = 0,
  }) {
    return Padding(
      padding:
          EdgeInsets.only(right: right, left: left, top: top, bottom: bottom),
      child: this,
    );
  }

  Widget paddingSymmetric({
    double horizontal = 0,
    double vertical = 0,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );
  }
}
