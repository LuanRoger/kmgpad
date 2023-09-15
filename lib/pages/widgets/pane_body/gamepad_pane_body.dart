import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kmgpad/providers/providers.dart';
import 'package:kmgpad/shared/widgets/icon_toggle_button.dart';
import 'package:kmgpad/shared/widgets/pane_body.dart';
import 'package:kmgpad/shared/widgets/thumbstick_viewer.dart';
import 'package:xinput_gamepad/xinput_gamepad.dart';

class GamepadPaneBody extends HookConsumerWidget {
  const GamepadPaneBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerManager = ref.watch(controllerManagerProvider);

    final enableSwitchState = useState(true);
    final lockControllersState = useState(false);

    final thumbViewerLxState = useState(0);
    final thumbViewerLyState = useState(0);
    final thumbViewerRxState = useState(0);
    final thumbViewerRyState = useState(0);

    useEffect(() {
      void updateThumbLxViewer(int tx) {
        thumbViewerLxState.value = tx;
      }

      void updateThumbLyViewer(int ty) {
        thumbViewerLyState.value = ty;
      }

      void updateThumbRxViewer(int rx) {
        thumbViewerRxState.value = rx;
      }

      void updateThumbRyViewer(int ry) {
        thumbViewerRyState.value = ry;
      }

      controllerManager.addVariableButtonAction(
        variableKey: VariableControllerKey.THUMB_LX,
        action: updateThumbLxViewer,
      );
      controllerManager.addVariableButtonAction(
        variableKey: VariableControllerKey.THUMB_LY,
        action: updateThumbLyViewer,
      );
      controllerManager.addVariableButtonAction(
        variableKey: VariableControllerKey.THUMB_RX,
        action: updateThumbRxViewer,
      );
      controllerManager.addVariableButtonAction(
        variableKey: VariableControllerKey.THUMB_RY,
        action: updateThumbRyViewer,
      );

      return () {
        controllerManager.removeVariableButtonAction(
          variableKey: VariableControllerKey.THUMB_LX,
          action: updateThumbLxViewer,
        );
        controllerManager.removeVariableButtonAction(
          variableKey: VariableControllerKey.THUMB_LY,
          action: updateThumbLyViewer,
        );
        controllerManager.removeVariableButtonAction(
          variableKey: VariableControllerKey.THUMB_RX,
          action: updateThumbRxViewer,
        );
        controllerManager.removeVariableButtonAction(
          variableKey: VariableControllerKey.THUMB_RY,
          action: updateThumbRyViewer,
        );
      };
    });

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
              ),
              IconToggleButton(
                pressed: lockControllersState.value,
                pressedIcon: const Icon(FluentIcons.lock),
                unpressedIcon: const Icon(FluentIcons.unlock),
                onChanged: (newValue) {
                  lockControllersState.value = newValue;
                  controllerManager.lock = lockControllersState.value;
                },
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: ThumbstickView(
                  x: thumbViewerLxState.value,
                  y: thumbViewerLyState.value,
                ),
              ),
              SizedBox(
                width: 120,
                height: 120,
                child: ThumbstickView(
                  x: thumbViewerRxState.value,
                  y: thumbViewerRyState.value,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
