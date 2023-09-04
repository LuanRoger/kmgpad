import 'package:fluent_ui/fluent_ui.dart';

class NavigationViewThemed extends StatelessWidget {
  final int selected;
  final Function(int)? onChanged;
  final List<NavigationPaneItem> items;
  final List<NavigationPaneItem> footerItems;

  const NavigationViewThemed({
    super.key,
    required this.selected,
    this.items = const [],
    this.onChanged,
    this.footerItems = const [],
  });

  @override
  Widget build(BuildContext context) {
    return NavigationPaneTheme(
      data: const NavigationPaneThemeData(
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOutQuint,
        animationDuration: Duration(milliseconds: 300),
      ),
      child: NavigationView(
        pane: NavigationPane(
            selected: selected,
            onChanged: onChanged,
            displayMode: PaneDisplayMode.compact,
            items: items,
            footerItems: footerItems),
      ),
    );
  }
}
