class RouteData {
  final Map<String, dynamic> params;
  final Map<String, dynamic> query;
  final String path;
  final String name;
  RouteData._({ this.params, this.query, this.path, this.name });

  factory RouteData.create({ 
    String name, 
    String path, 
    Map<String, dynamic> params = const {}, 
    Map<String, dynamic> query = const {} 
  }){
    return RouteData._(
      name: name,
      query: query,
      params: params,
      path: path, 
    );
  }
}