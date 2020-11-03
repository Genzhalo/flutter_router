library pages_router;

import 'package:flutter/material.dart';
import 'package:pages_router/router_data.dart';
import 'package:pages_router/router_defenition.dart';
import 'package:pages_router/router_page.dart';

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
      onPopPage: widget.pagesRouter._onPopPage
    );
  } 
}

class PagesRouter extends ChangeNotifier {
  final GlobalKey<NavigatorState> navigationKey;
  final List<RouteDefinition> routes;
  final String initialPath;

  PagesRouter({  @required this.navigationKey, this.routes = const [], this.initialPath = "/" }) {
    goByPath(initialPath);
  }

  List<RoutePage> _pages = [];
  List<RoutePage> get pages => _pages;

  RouteData _currentRoute;
  RouteData get currentRoute => _currentRoute;

  RouteDefinition findRoute(bool Function(RouteDefinition) predicate){
    var route = routes.firstWhere(
      (route) => predicate(route),
      orElse: () => null
    );
    return route != null ? route : routes.firstWhere((route) => route.name == "unknown");
  }

  void goByName(String name, { Map<String, String> arguments = const {},  Map<String, String> query = const {} }) {
    final route = findRoute((route) => route.name == name);
    _currentRoute = RouteData.create(
      name: name, 
      params: arguments, 
      query: query, 
      path: route.toPath(arguments)
    );
    _pages = route.handler(_currentRoute); 
    notifyListeners();
  }

  void goByPath(String path) {
    final uri = Uri.parse(path);
    final uriPath = uri.path.trim();
    final route = routes.firstWhere(
      (route) => route.path == uriPath, 
      orElse: () => findRoute((route) => route.hasMatch(uriPath))
    );
    _currentRoute = RouteData.create(
      name: route.name, 
      params: route.getParams(uriPath), 
      query: uri.queryParameters, 
      path: uri.path
    );
    _pages = route.handler(_currentRoute); 
    notifyListeners();
  }

  @override
  void dispose() {
    routes.clear();
    super.dispose();
  }

  bool _onPopPage(Route page, result) {
    _pages.removeLast();
    final path = pages
      .map((p) => p.fragment)
      .join("/")
      .replaceAll("//", "/");
    goByPath(path);
    return page.didPop(result);
  }
}