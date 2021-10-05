import 'package:flutter/material.dart';

class AppFutureBuilder<T> extends StatelessWidget {
  const AppFutureBuilder({
    Key? key,
    required this.future,
    required this.builder,
    this.loader = const SizedBox.shrink(),
  }) : super(key: key);

  final Future<T> future;
  final Widget Function(BuildContext, T) builder;
  final Widget loader;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          throw snapshot.error.toString();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return builder(context, snapshot.data as T);
        }

        return const SizedBox.shrink();
      },
    );
  }
}
