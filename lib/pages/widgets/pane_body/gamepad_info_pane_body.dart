import 'package:flutter/material.dart';
import 'package:kmgpad/shared/widgets/pane_body.dart';

class GamepadInfoPaneBody extends StatelessWidget {
  const GamepadInfoPaneBody({super.key});

  @override
  Widget build(BuildContext context) {
    return PaneBody(
      title: Text("Gamepad Info"),
      child: Center(
        child: Text("Gamepad info"),
      ),
    );
  }
}
