import 'package:flutter/cupertino.dart';
import 'package:pages_router/route_data.dart';
import 'package:path_to_regexp/path_to_regexp.dart';

class RoutePath  {
  final String path;
  final String name;
  final List<Page> Function(RouteEntry) handler;
  final RoutePath parent;
  List<String> _parameters = [];
  RegExp _pathRegExp;

  RoutePath({
    @required this.name, 
    @required this.path, 
    @required this.handler, 
    this.parent
  }) {
    _pathRegExp = pathToRegExp(path, parameters: _parameters);
  }

  bool hasMatch(String _fragment) => _pathRegExp.hasMatch(_fragment);

  Map<String, dynamic> getParams(String fragment) =>
    extract(_parameters, _pathRegExp.matchAsPrefix(fragment)); 

  String toPath(Map<String, String> params) {
    final toPath = pathToFunction(path);
    return toPath(params); 
  }

  String toString() => " \n RoutePath name: $name, path: $path";

}