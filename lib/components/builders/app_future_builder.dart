import 'package:flutter/material.dart';

class AppFutureBuilder<T> extends StatelessWidget {
  const AppFutureBuilder({
    Key? key,
    required this.future,
    required this.builder,
    this.initialData,
    this.loader = const SizedBox.shrink(),
    this.skipFuture = false,
  }) : super(key: key);

  const AppFutureBuilder.skipFuture({
    Key? key,
    required this.future,
    required this.builder,
    required this.initialData,
    this.loader = const SizedBox.shrink(),
    this.skipFuture = true,
  }) : super(key: key);

  final Future<T> future;
  final T? initialData;
  final Widget Function(BuildContext context, T value) builder;
  final Widget loader;

  final bool skipFuture;

  @override
  Widget build(BuildContext context) {
    if (skipFuture && initialData != null) {
      return builder(context, initialData!);
    }
    return FutureBuilder(
      future: future,
      initialData: initialData,
      builder: (context, AsyncSnapshot<T> snapshot) {
        if (snapshot.hasError) {
          throw snapshot.error.toString();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return builder(context, snapshot.data as T);
        }

        return loader;
      },
    );
  }
}
