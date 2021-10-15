import 'package:flutter/material.dart';

class AppStreamBuilder<T> extends StatelessWidget {
  const AppStreamBuilder({
    Key? key,
    required this.stream,
    required this.builder,
    this.initialData,
    this.loader,
  }) : super(key: key);

  final Stream<T> stream;
  final T? initialData;
  final Widget Function(BuildContext context, T value) builder;
  final Widget? loader;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      initialData: initialData,
      builder: (context, AsyncSnapshot<T?> snapshot) {
        if (snapshot.hasError) {
          throw snapshot.error.toString();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return loader ?? const SizedBox.shrink();
        }

        return builder(context, snapshot.data as T);
      },
    );
  }
}
