import 'package:flutter/material.dart';

abstract class RouteDefinition {
  String get segment;
  String get name;
  List<Page> getPages(RouteEntry);
  List<RouteDefinition> get routes => [];
}
