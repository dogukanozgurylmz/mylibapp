import 'package:flutter/material.dart';

enum CircularRadius {
  /// circular 10
  xs(Radius.circular(10)),

  /// circular 15
  s(Radius.circular(15)),

  /// circular 20
  m(Radius.circular(20)),

  /// circular 25
  l(Radius.circular(25)),

  /// circular 30
  xl(Radius.circular(30));

  final Radius value;
  const CircularRadius(this.value);
}
