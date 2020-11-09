import 'package:flutter/material.dart';
import 'route_data.dart';

abstract class RouteDefinition {
  String get segment;
  String get name;
  List<Page> getPages(RouteEntry data);
  List<RouteDefinition> get routes => [];
}
