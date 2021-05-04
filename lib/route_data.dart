import 'package:pages_router/route-path.dart';

class RouteEntry {
  final RoutePath? routePath;
  final Uri uri;

  RouteEntry({ required this.uri, this.routePath });

  String get path => uri.path;

  String get name => routePath!.name;

  Map<String, dynamic> get params => routePath!.getParams(path);

  Map<String, dynamic> get query => uri.queryParameters;

}