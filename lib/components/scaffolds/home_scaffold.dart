import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prompts_game/components/bodies/home_body.dart';
import 'package:prompts_game/components/bodies/messages_body.dart';
import 'package:prompts_game/components/bodies/profile_body.dart';
import 'package:prompts_game/components/scaffolds/profile_edit_scaffold.dart';
import 'package:prompts_game/models/app_profile.dart';

class HomeScaffold extends StatefulWidget {
  const HomeScaffold({Key? key, required this.userProfile}) : super(key: key);

  final AppProfile userProfile;

  @override
  State<StatefulWidget> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  int _selectedIndex = 0;

  late AppProfile _userProfile;

  void _setUserProfile(AppProfile userProfile) {
    setState(() {
      _userProfile = userProfile;
    });
  }

  void _onProfileEditPress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ProfileEditScaffold(
            onProfileEdited: _setUserProfile,
            userProfile: _userProfile,
          );
        },
      ),
    );
  }

  void _setSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _userProfile = widget.userProfile;
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      _setSelectedIndex(0);
      return false;
    }

    bool popDialog = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to exit Promptsi?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    return popDialog;
  }

  @override
  Widget build(BuildContext context) {
    final _appBarOptions = <PreferredSizeWidget>[
      AppBar(
        title: const Text('promptsi'),
        actions: const [
          // todo: _onCreatePromptClick

        ],
      ),
      AppBar(title: const Text("Messages")),
      AppBar(
        title: Text(_userProfile.firstName),
        actions: [
          IconButton(
            onPressed: _onProfileEditPress,
            icon: const FaIcon(FontAwesomeIcons.edit),
          ),
        ],
      ),
    ];

    final _bodyOptions = <Widget>[
      const HomeBody(),
      const MessagesBody(),
      ProfileBody.currentUser(profile: _userProfile),
    ];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: _appBarOptions.elementAt(_selectedIndex),
        body: _bodyOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(Icons.message),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(Icons.account_circle),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _setSelectedIndex,
        ),
      ),
    );
  }
}
