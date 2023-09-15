import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kmgpad/pages/widgets/pane_body/gamepad_info_pane_body.dart';
import 'package:kmgpad/pages/widgets/pane_body/gamepad_pane_body.dart';
import 'package:kmgpad/pages/widgets/pane_body/settings_pane_body.dart';
import 'package:kmgpad/providers/providers.dart';
import 'package:kmgpad/shared/widgets/navigation_view_themed.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedPaneState = useState(0);

    return NavigationViewThemed(
        selected: selectedPaneState.value,
        onChanged: (newIndex) => selectedPaneState.value = newIndex,
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.game),
            title: const Text("Gamepad"),
            body: const GamepadPaneBody(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.info),
            title: const Text("Gamepad Info"),
            body: const GamepadInfoPaneBody(),
          )
        ],
        footerItems: [
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            body: const SettingsPaneBody(),
          )
        ]);
  }
}
