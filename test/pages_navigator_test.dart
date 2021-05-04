import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pages_router/pages_navigator.dart';
import 'package:pages_router/route_defenition.dart';

class WelcomRouteDefenition extends RouteDefinition {

  @override
  List<Page> getPages(RouteEntry) => [ RootPage() ];

  @override
  String get name => "welcome";

  @override
  String get segment => "/welcome";

}


class RootRouteDefenition extends RouteDefinition {

  @override
  List<Page> getPages(_) => [ RootPage() ];

  @override
  String get name => "root";

  @override
  String get segment => "/";

  @override

  List<RouteDefinition> get routes => [
    UsersRouteDefenition(),
    AboutRouteDefenition()
  ];

}


class UsersRouteDefenition extends RouteDefinition {

  @override
  List<Page> getPages(RouteEntry) => [ UsersPage() ];

  @override
  String get name => "users";

  @override
  String get segment => "/users";

  @override
  List<RouteDefinition> get routes => [
    UserRouteDefenition()
  ];

}

class UserRouteDefenition extends RouteDefinition {

  @override
  List<Page> getPages(data) => [ UserPage(userId: data.params["userId"]) ];

  @override
  String get name => "user";

  @override
  String get segment => "/:userId";

  @override
  List<RouteDefinition> get routes => [
    StoriesRouteDefenition()
  ];

}

class StoriesRouteDefenition extends RouteDefinition {

  @override
  List<Page> getPages(data) => [  ];

  @override
  String get name => "strories";

  @override
  String get segment => "/strories";

  @override
  List<RouteDefinition> get routes => [
    StoryRouteDefenition()
  ];


}

class StoryRouteDefenition extends RouteDefinition {

  @override
  List<Page> getPages(data) => [  ];

  @override
  String get name => "story";

  @override
  String get segment => "/:storyId";

}

class AboutRouteDefenition extends RouteDefinition {

  @override
  List<Page> getPages(data) => [  ];

  @override
  String get name => "about";

  @override
  String get segment => "/about";

}


final router = PagesRouter(
    initialPath: "/",
    navigationKey: GlobalKey<NavigatorState>(),
    routes: [
      WelcomRouteDefenition(),
      RootRouteDefenition()
    ]
  );

class RootWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Root"),),
      body: IconButton(
        icon: Icon(Icons.people),
        onPressed: (){ router.goByName("users"); } ,
      )
    );
  }
}

class UsersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Users")),
      body: ListView(
        children: [
          ListTile(
            title: Text("User1"),
            onTap: () { router.goByName("user", arguments: { "userId": "1" }); },
          ),
          ListTile(
            title: Text("User2"),
            onTap: () { router.goByName("user", arguments: { "userId": "2" }); },
          ),
          ListTile(
            title: Text("User3"),
            onTap: () { router.goByPath("${router.currentRoute!.path}/3?isText=true"); },
          )
        ],
      )
    );
  }
}

class UserWidget extends StatelessWidget {
  final String? userId;
  UserWidget({ this.userId });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User")),
      body: Text("userId $userId")
    );
  }
}

class RootPage extends MaterialPage {
  RootPage() : super(child: RootWidget());
}

class UsersPage extends MaterialPage {
  UsersPage() : super(child: UsersWidget());
}

class UserPage extends MaterialPage {
  final String? userId;
  UserPage({ this.userId }) : super(child: UserWidget(userId: userId));
}

void main() {
  final myApp = MaterialApp(
    home: PagesNavigator(pagesRouter: router)
  );
  testWidgets('Pages navigator text', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(myApp);

    // start with root
    expect(find.text('Root'), findsOneWidget);
    expect(find.text('1'), findsNothing);
    expect("root", router.currentRoute!.name);

    // route to users
    await tester.tap(find.byIcon(Icons.people));
    await tester.pump();
    final userId1 = "1";
    final userId2 = "2";
    final userId3 = "3";
    expect(find.text('User$userId1'), findsOneWidget);
    expect(find.text('User$userId2'), findsOneWidget);
    expect(find.text('User$userId3'), findsOneWidget);

    // route to user 1
    await tester.tap(find.text("User$userId1"));
    await tester.pump();
    expect(find.text('userId $userId1'), findsOneWidget);
    expect("user", router.currentRoute!.name);
    
     // route back to users
    router.navigationKey.currentState!.pop();
    await tester.pump();
  
    expect(find.text('User$userId1'), findsOneWidget);
    expect(find.text('User$userId2'), findsOneWidget);
    expect(find.text('User$userId3'), findsOneWidget);
    expect("users", router.currentRoute!.name);

    // route to user 2
    await tester.tap(find.text("User$userId2"));
    await tester.pump();
    expect(find.text('userId $userId2'), findsOneWidget);
    expect("user", router.currentRoute!.name);

    // route back to users
    router.navigationKey.currentState!.pop();
    await tester.pump();
    expect(find.text('User$userId1'), findsOneWidget);
    expect(find.text('User$userId2'), findsOneWidget);
    expect(find.text('User$userId3'), findsOneWidget);
    expect("users", router.currentRoute!.name);

     // route to user 3
    await tester.tap(find.text("User$userId3"));
    await tester.pump();
    expect(find.text('userId $userId3'), findsOneWidget);
    expect("user", router.currentRoute!.name);

    // route back to users
    router.navigationKey.currentState!.pop();
    await tester.pump(Duration(seconds: 1));
    expect("users", router.currentRoute!.name);

    // route back to root
    router.navigationKey.currentState!.pop();
    await tester.pump();
    expect("root", router.currentRoute!.name);

    router.navigationKey.currentState!.pop();
    await tester.pump();
    expect("root", router.currentRoute!.name);

    router.navigationKey.currentState!.pop();
    await tester.pump();
    expect("root", router.currentRoute!.name);
    
    router.navigationKey.currentState!.pop();
    await tester.pump();
    expect("root", router.currentRoute!.name);

    router.goByName("welcome");
    await tester.pump();
    expect("welcome", router.currentRoute!.name);

    router.navigationKey.currentState!.pop();
    await tester.pump();
    expect("welcome", router.currentRoute!.name);

  });
}