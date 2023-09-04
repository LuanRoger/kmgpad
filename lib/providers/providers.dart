import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kmgpad/providers/interfaces/controllers_manager_notifier.dart';
import 'package:xinput_gamepad/xinput_gamepad.dart';

final controllersProvider = Provider<List<Controller>>((ref) {
  final controllers = List<Controller>.empty(growable: true);
  for (var controllerIndex = 0; controllerIndex < 4; controllerIndex++) {
    final controller = Controller(index: controllerIndex);
    controllers.add(controller);
  }
  return controllers;
});
final controllerManagerProvider =
    ChangeNotifierProvider<ControllersManagerNotifier>((ref) {
  final controllers = ref.watch(controllersProvider);

  final manager = ControllersManager(controllers);
  final managerNotifier = ControllersManagerNotifier(controllers: manager);
  managerNotifier.mapControllersButton();
  return managerNotifier;
});
