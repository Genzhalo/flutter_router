import 'package:flutter/foundation.dart';
import 'package:pages_router/router_data.dart';
import 'package:pages_router/router_page.dart';
import 'package:path_to_regexp/path_to_regexp.dart';

class RouteDefinition {
  final String path;
  final String name;
  final List<RoutePage> Function(RouteData) handler;
  List<String> _parameters = [];
  RegExp _pathRegExp;

  RouteDefinition({@required this.name,  @required this.path, @required this.handler }) {
    _pathRegExp = pathToRegExp(path, parameters: _parameters);
  }

  bool hasMatch(String fragment) => _pathRegExp.hasMatch(fragment);

  Map<String, dynamic> getParams(String fragment) =>
    extract(_parameters, _pathRegExp.matchAsPrefix(fragment)); 

  String toPath(Map<String, String> params) {
    final toPath = pathToFunction(path);
    return toPath(params); 
  }
}