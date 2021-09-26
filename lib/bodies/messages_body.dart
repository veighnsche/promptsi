import 'package:flutter/material.dart';

class MessagesBody extends StatefulWidget {
  const MessagesBody({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MessagesBodyState();
}

class _MessagesBodyState extends State<MessagesBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
      ),
      body: const Center(child: Text('lalala'))
    );
  }
}