import 'package:fluent_ui/fluent_ui.dart';
import 'package:kmgpad/pages/home_page.dart';
import 'package:kmgpad/shared/widgets/window_bar.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      themeMode: ThemeMode.dark,
      theme: FluentThemeData(
        accentColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: const Column(
        children: [
          Flexible(
            flex: 0,
            child: WindowBar(),
          ),
          Expanded(
            child: HomePage(),
          ),
        ],
      ),
    );
  }
}
