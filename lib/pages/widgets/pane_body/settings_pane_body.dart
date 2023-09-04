import 'package:flutter/material.dart';
import 'package:kmgpad/shared/widgets/pane_body.dart';

class SettingsPaneBody extends StatelessWidget {
  const SettingsPaneBody({super.key});
  
  @override
  Widget build(BuildContext context) {
    return PaneBody(
      title: Text("Settings"),
      child: Center(
        child: Text("Settings"),
      ),
    );
  }
}