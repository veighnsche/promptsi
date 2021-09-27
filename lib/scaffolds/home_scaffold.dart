import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prompts_game/bodies/my_profile_body.dart';
import 'package:prompts_game/bodies/home_body.dart';
import 'package:prompts_game/bodies/messages_body.dart';
import 'package:prompts_game/interfaces/app_profile.dart';

class HomeScaffold extends StatefulWidget {
  const HomeScaffold({Key? key, required this.userProfile}) : super(key: key);

  final AppProfile userProfile;

  @override
  State<StatefulWidget> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  int _selectedIndex = 0;

  static const List<Widget> _bodyOptions = <Widget>[
    HomeBody(),
    MessagesBody(),
    MyProfileBody(),
  ];

  final List<PreferredSizeWidget> _appBarOptions = <PreferredSizeWidget>[
    AppBar(
      title: const Text('Prompts'),
    ),
    AppBar(
      title: const Text("Messages"),
    ),
    AppBar(
      title: const Text('Account'),
      actions: [
        IconButton(
            onPressed: FirebaseAuth.instance.signOut,
            icon: const Icon(Icons.logout))
      ]
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarOptions.elementAt(_selectedIndex),
      body: _bodyOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
