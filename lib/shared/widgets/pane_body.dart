import 'package:flutter/material.dart';

class PaneBody extends StatelessWidget {
  final Widget title;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const PaneBody(
      {super.key, required this.title, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 3,
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.titleLarge!,
              child: title,
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 10,
            child: child,
          ),
        ],
      ),
    );
  }
}
