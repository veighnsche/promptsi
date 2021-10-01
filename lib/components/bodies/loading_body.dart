import 'package:flutter/material.dart';

class LoadingBody extends StatefulWidget {
  const LoadingBody({Key? key}) : super(key: key);

  @override
  State<LoadingBody> createState() => _LoadingBodyState();
}

class _LoadingBodyState extends State<LoadingBody> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
