import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pages_router/pages_navigator.dart';
import 'package:pages_router/router_defenition.dart';

final router = PagesRouter(
    initialPath: "/",
    navigationKey: GlobalKey<NavigatorState>(),
    routes: [
      RouteDefinition(
        path: "/", 
        name: "root",
        handler: (_) => [ RootPage() ]
      ),
      RouteDefinition(
        path: "/users", 
        name: "users", 
        handler: (_) => [ 
          RootPage(),
          UsersPage()
        ], 
      ),
      RouteDefinition(
        path: "/users/:userId", 
        name: "user",
        handler: (data) => [
          RootPage(),
          UsersPage(),
          UserPage(userId: data.params["userId"])
        ]
      ),
      RouteDefinition(path: "/users/:userId/stories", handler: (_) => [], name: "userStrories"),
      RouteDefinition(path: "/users/:userId/stories/:stotyId", handler: (_) => [], name: "userStrory"),
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
            onTap: () { router.goByPath("${router.currentRoute.path}/3?isText=true"); },
          )
        ],
      )
    );
  }
}

class UserWidget extends StatelessWidget {
  final String userId;
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
  final String userId;
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
    expect("root", router.currentRoute.name);


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
    expect("user", router.currentRoute.name);
    
     // route back to users
    router.navigationKey.currentState.pop();
    await tester.pump(Duration(seconds: 1));
  
    expect(find.text('User$userId1'), findsOneWidget);
    expect(find.text('User$userId2'), findsOneWidget);
    expect(find.text('User$userId3'), findsOneWidget);
    expect("users", router.currentRoute.name);

    // route to user 2
    await tester.tap(find.text("User$userId2"));
    await tester.pump();
    expect(find.text('userId $userId2'), findsOneWidget);
    expect("user", router.currentRoute.name);

    // route back to users
    router.navigationKey.currentState.pop();
    await tester.pump(Duration(seconds: 1));
    expect(find.text('User$userId1'), findsOneWidget);
    expect(find.text('User$userId2'), findsOneWidget);
    expect(find.text('User$userId3'), findsOneWidget);
    expect("users", router.currentRoute.name);

     // route to user 3
    await tester.tap(find.text("User$userId3"));
    await tester.pump();
    expect(find.text('userId $userId3'), findsOneWidget);
    expect("user", router.currentRoute.name);

    // route back to users
    router.navigationKey.currentState.pop();
    await tester.pump(Duration(seconds: 1));
    expect("users", router.currentRoute.name);

    // route back to root
    router.navigationKey.currentState.pop();
    await tester.pump();
    expect("root", router.currentRoute.name);
  });
}