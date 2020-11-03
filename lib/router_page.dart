import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class RoutePage extends MaterialPage {
  RoutePage({ @required Widget child, Key key }) : super(child: child, key: key);
  String get fragment;
}
