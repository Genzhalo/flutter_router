import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pages_router/route_data.dart';

class RouteDefinition {
  final String segment;
  final String name;
  final List<Page> Function(RouteEntry) getPages;
  final List<RouteDefinition> routes;

  RouteDefinition({
    @required this.name, 
    @required this.segment, 
    @required this.getPages, 
    this.routes = const []
  });
}
