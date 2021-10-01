import 'package:flutter/material.dart';
import 'package:prompts_game/components/bodies/loading_body.dart';

class LoadingScaffold extends StatelessWidget {
  const LoadingScaffold({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loading')),
      body: const LoadingBody(),
    );
  }

}
