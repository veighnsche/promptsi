import 'package:flutter/material.dart';

class MyProfileBody extends StatefulWidget {
  const MyProfileBody({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyProfileBodyState();
}

class _MyProfileBodyState extends State<MyProfileBody> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('My Profile'),
    );
  }
}
