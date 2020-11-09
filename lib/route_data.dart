class RouteEntry {
  final Map<String, dynamic> params;
  final Map<String, dynamic> query;
  final String path;
  final String name;
  RouteEntry._({ this.params, this.query, this.path, this.name });

  factory RouteEntry.create({ 
    String name, 
    String path, 
    Map<String, dynamic> params = const {}, 
    Map<String, dynamic> query = const {}
  }){
    return RouteEntry._(
      name: name,
      query: query,
      params: params,
      path: path, 
    );
  }

  String get redirectTo => query.containsKey("redirectTo") ? query["redirectTo"] : null;
}