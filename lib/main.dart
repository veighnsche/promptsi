import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/routers/is_signed_in_router.dart';
import 'package:prompts_game/scaffolds/error_scaffold.dart';
import 'package:prompts_game/scaffolds/loading_scaffold.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prompts game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorScaffold(message: 'Error loading FlutterFire');
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return const IsSignedInRouter();
          }

          return const LoadingScaffold();
        },
      ),
    );
  }
}
