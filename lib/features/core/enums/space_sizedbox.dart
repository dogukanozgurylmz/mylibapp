import 'package:flutter/material.dart';

enum SpaceVerticalSizedBox {
  /// 5
  xs(SizedBox(height: 5)),

  /// 10
  s(SizedBox(height: 10)),

  /// 15
  m(SizedBox(height: 15)),

  /// 20
  l(SizedBox(height: 20)),

  /// 25
  xl(SizedBox(height: 25));

  final SizedBox value;
  const SpaceVerticalSizedBox(this.value);
}

enum SpaceHorizontalSizedBox {
  /// 5
  xs(SizedBox(width: 5)),

  /// 10
  s(SizedBox(width: 10)),

  /// 15
  m(SizedBox(width: 15)),

  /// 20
  l(SizedBox(width: 20)),

  /// 25
  xl(SizedBox(width: 25));

  final SizedBox value;
  const SpaceHorizontalSizedBox(this.value);
}
