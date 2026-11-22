import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  static const gapXs = SizedBox.square(dimension: xs);
  static const gapSm = SizedBox.square(dimension: sm);
  static const gapMd = SizedBox.square(dimension: md);
  static const gapLg = SizedBox.square(dimension: lg);
  static const gapXl = SizedBox.square(dimension: xl);
}

abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 20;

  static const card = BorderRadius.all(Radius.circular(md));
}
