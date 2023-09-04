import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kmgpad/shared/widgets/pane_body.dart';
import 'package:kmgpad/shared/widgets/thumbstick_viewer.dart';

class GamepadPaneBody extends HookWidget {
  const GamepadPaneBody({super.key});

  @override
  Widget build(BuildContext context) {
    final enableSwitchState = useState(true);

    return PaneBody(
      title: Text("Gamepad"),
      child: Column(
        children: [
          Row(
            children: [
              const Text("Enabled: "),
              ToggleSwitch(
                checked: enableSwitchState.value,
                onChanged: (newValue) => enableSwitchState.value = newValue,
              )
            ],
          ),
          const Row(
            children: [
              const SizedBox(
                width: 120,
                height: 120,
                child: ThumbstickView(x: 0, y: 32767),
              ),
              const SizedBox(
                width: 120,
                height: 120,
                child: ThumbstickView(x: 0, y: 0),
              )
            ],
          )
        ],
      ),
    );
  }
}
