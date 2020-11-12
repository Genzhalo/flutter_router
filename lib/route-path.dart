import 'package:flutter/cupertino.dart';
import 'package:pages_router/route_data.dart';
import 'package:pages_router/route_defenition.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
 

class _RoutePathHelper {
  static String buildPath(RoutePath routePath) {
    var path = "";
    do {
      path = routePath.routeDefinition.segment + path;
    } while((routePath = routePath.parent) != null);
    return path.replaceAll("//", "/");
  }
}


class RoutePath  {
  final RoutePath parent;
  final RouteDefinition routeDefinition;
  String _path;
  List<String> _parameters = [];
  RegExp _pathRegExp;

  RoutePath({ this.parent, @required this.routeDefinition }) {
    _path = _RoutePathHelper.buildPath(this);
    _pathRegExp = pathToRegExp(path, parameters: _parameters);
  }

  String get name => routeDefinition.name;

  String get path => _path;

  List<Page> handler(RouteEntry data){
    List<Page> pages = [];
    var routePath = this;
    do {
      pages.insertAll(0, routePath.routeDefinition.getPages(data));
      routePath = routePath.parent;
    } while(routePath != null);
    return pages;
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
