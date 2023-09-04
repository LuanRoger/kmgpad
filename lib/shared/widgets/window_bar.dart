import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show Theme;
import 'package:window_manager/window_manager.dart';

class WindowBar extends StatelessWidget {
  const WindowBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeBrightness = Theme.of(context).brightness;

    return Container(
      height: 35,
      width: double.infinity,
      color: Colors.transparent,
      child: Row(
        children: [
          const Expanded(
            child: DragToMoveArea(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 5),
                    child: FlutterLogo(),
                  ),
                  Text(
                    "KMGPad",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: WindowCaption(
              backgroundColor: Colors.transparent,
              brightness: themeBrightness,
            ),
          )
        ],
      ),
    );
  }
}
