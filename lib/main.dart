import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/components/builders/app_future_builder.dart';
import 'package:prompts_game/components/switches/is_signed_in_switch.dart';
import 'package:prompts_game/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Promptsi',
      theme: themeData,
      home: AppFutureBuilder(
        future: _initialization,
        builder: (context, _) {
          return const IsSignedInSwitch();
        },
      ),
    );
  }
}
