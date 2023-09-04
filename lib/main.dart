import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kmgpad/app.dart';
import 'package:window_manager/window_manager.dart';
import 'package:xinput_gamepad/xinput_gamepad.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Window.initialize();
  await WindowManager.instance.ensureInitialized();
  XInputManager.enableXInput();

  await windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitleBarStyle(
      TitleBarStyle.hidden,
      windowButtonVisibility: false,
    );
    await windowManager.setSize(const Size(800, 600));
    await windowManager.setMinimumSize(const Size(500, 400));
    await windowManager.center();
    await Window.setEffect(
      effect: WindowEffect.mica,
    );
  });

  runApp(const ProviderScope(child: App()));
}
