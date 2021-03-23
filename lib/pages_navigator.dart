library pages_router;

import 'package:flutter/material.dart';
import 'package:pages_router/route-path.dart';
import 'package:pages_router/route_data.dart';
import 'package:pages_router/route_defenition.dart';

class PagesNavigator extends StatefulWidget {
  final PagesRouter pagesRouter;
  PagesNavigator({ this.pagesRouter });
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<PagesNavigator> {
  @override
  void initState() {
    widget.pagesRouter.addListener(_rebuild);
    super.initState();
  }

  @override
  void dispose() {
    widget.pagesRouter.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild(){
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.pagesRouter.navigationKey,
      pages: widget.pagesRouter.pages,
      onPopPage: widget.pagesRouter.onPopPage
    );
  } 
}

class PagesRouter extends ChangeNotifier {
  final GlobalKey<NavigatorState> navigationKey;
  final String initialPath;
  
  List<RoutePath> _routes = [];

  PagesRouter({ @required this.navigationKey, @required this.initialPath, List<RouteDefinition> routes = const [] }) {
    _initRoutes(null ,routes);
    goByPath(initialPath);
  }

  List<Page> _pages = [];
  List<Page> get pages => _pages;

  RouteEntry _currentRoute;
  RouteEntry get currentRoute => _currentRoute;

  void goByName(String name, { Map<String, String> arguments = const {},  Map<String, dynamic> query = const {} }) {
    final route = _findRoute((route) => route.name == name);
    final uri = Uri(
      path: route.toPath(arguments),
      queryParameters: query
    );
    _currentRoute = RouteEntry(uri: uri, routePath: route);
    _go(route);
  }

  void goByPath(String path) {
    final uri = Uri.parse(path);
    final uriPath = uri.path.trim();
    final route = _routes.firstWhere(
      (route) => route.path == uriPath, 
      orElse: () => _findRouteByPath(uriPath)
    );
    _currentRoute = RouteEntry(uri: uri, routePath: route);
    _go(route);
  }

  bool onPopPage(Route page, result) {
    final route = _findRoute((r) => r.name == currentRoute.name);
    if (route == null || route.parent == null) return false;
    goByName(route.parent.name, arguments: currentRoute.params, query: currentRoute.query);
    return page.didPop(result);
  }

  @override
  void dispose() {
    _routes.clear();
    super.dispose();
  }

  void _go(RoutePath routeDefinition){
    _pages = routeDefinition.handler(currentRoute); 
    notifyListeners();
  }

  RoutePath _findRouteByPath(String path){
    final searchRoutes = _routes.where((route) => route.hasMatch(path)).toList();
    if (searchRoutes.isEmpty) return _routes.firstWhere((route) => route.name == "unknown");
    RoutePath result;
    int prevIndexOf = -1;
    for (var route in searchRoutes) {
      final index = route.path.indexOf("/:");
      if (index == -1) {
        result = route;
        break;
      }
      if (index > prevIndexOf) {
        result = route;
        prevIndexOf = index;
      }
    }
    return result;
  }


  RoutePath _findRoute(bool Function(RoutePath) predicate){
    var route = _routes.firstWhere(
      (route) => predicate(route),
      orElse: () => null
    );
    return route != null ? route : _routes.firstWhere((route) => route.name == "unknown");
  }


  void _initRoutes(RoutePath parent, List<RouteDefinition> routes){
    for (var route in routes) {
      final path = RoutePath(parent: parent, routeDefinition: route);
      _routes.add(path);
      _initRoutes(path, route.routes);
    }
  }
}