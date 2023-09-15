import 'package:fluent_ui/fluent_ui.dart';
import 'package:kmgpad/shared/utils/controller_utils.dart';
import 'package:virtual_cursor/virtual_cursor.dart';
import 'package:virtual_keyboard/virtual_keyboard.dart';
import 'package:xinput_gamepad/xinput_gamepad.dart';

//Part of this code was taken from https://github.com/Tylemagne/Gopher360.

class ControllersManagerNotifier extends ChangeNotifier {
  final ControllersManager controllers;
  final _ControllerMappingDefaults _controllerMapping;
  bool get lock => _controllerMapping.lock;
  set lock(bool value) {
    _controllerMapping.lock = value;
    notifyListeners();
  }

  late final Map<ControllerButton, List<void Function()>> _buttonsMapping;
  late final Map<VariableControllerKey, List<void Function(int)>>
      _variableKeysMapping;
  late final Map<ControllerButton, List<void Function()>>
      _buttonMappingNonLocking;
  late final Map<VariableControllerKey, List<void Function(int)>>
      _variableKeysMappingNonLocking;

  ControllersManagerNotifier({
    required this.controllers,
    double cursorSensitivity = 0.2,
    double deadzone = 0,
    bool lock = false,
  }) : _controllerMapping = _ControllerMappingDefaults(
          cursor: Cursor(),
          keyboard: Keyboard(),
          cursorSensitivity: cursorSensitivity,
          deadzone: deadzone,
          lock: lock,
        ) {
    _buttonsMapping = {
      ControllerButton.LEFT_SHOULDER: List.empty(growable: true),
    };
    _variableKeysMapping = {
      VariableControllerKey.LEFT_TRIGGER: List.empty(growable: true),
      VariableControllerKey.RIGHT_TRIGGER: List.empty(growable: true),
      VariableControllerKey.THUMB_LX: List.empty(growable: true),
      VariableControllerKey.THUMB_LY: List.empty(growable: true),
      VariableControllerKey.THUMB_RX: List.empty(growable: true),
      VariableControllerKey.THUMB_RY: List.empty(growable: true),
    };
    _buttonMappingNonLocking = {
      ControllerButton.LEFT_SHOULDER: List.empty(growable: true),
    };
    _variableKeysMappingNonLocking = {
      VariableControllerKey.LEFT_TRIGGER: List.empty(growable: true),
      VariableControllerKey.RIGHT_TRIGGER: List.empty(growable: true),
      VariableControllerKey.THUMB_LX: List.empty(growable: true),
      VariableControllerKey.THUMB_LY: List.empty(growable: true),
      VariableControllerKey.THUMB_RX: List.empty(growable: true),
      VariableControllerKey.THUMB_RY: List.empty(growable: true),
    };
  }

  void mapControllersButton() {
    final buttonsMapping = _controllerMapping.mapButtons(
      _buttonsMapping,
      _buttonMappingNonLocking,
    );
    final variableKeysMapping = _controllerMapping.mapThumbs(
      _variableKeysMapping,
      _variableKeysMappingNonLocking,
    );

    for (var controller in controllers.controllers) {
      controller.buttonsMapping = buttonsMapping;
      controller.variableKeysMapping = variableKeysMapping;
      if (!controller.activated) controller.listen();
    }
  }

  void addControllerButtomAction({
    required ControllerButton button,
    required void Function() action,
  }) {
    _buttonsMapping[button]!.add(action);
    notifyListeners();
  }

  void removeControllerButtonAction({
    required ControllerButton button,
    required void Function() action,
  }) {
    _buttonsMapping[button]!.remove(action);
    notifyListeners();
  }

  void addVariableButtonAction({
    required VariableControllerKey variableKey,
    required void Function(int) action,
  }) {
    _variableKeysMapping[variableKey]!.add(action);
    notifyListeners();
  }

  void removeVariableButtonAction({
    required VariableControllerKey variableKey,
    required void Function(int) action,
  }) {
    _variableKeysMapping[variableKey]!.remove(action);
    notifyListeners();
  }
}

class _ControllerMappingDefaults {
  final Cursor _cursor;
  final Keyboard _keyboard;
  final double cursorSensitivity;
  final double deadzone;
  bool lock;

  _ControllerMappingDefaults({
    required Cursor cursor,
    required Keyboard keyboard,
    this.deadzone = 0,
    this.cursorSensitivity = 0.2,
    this.lock = false,
  })  : _cursor = cursor,
        _keyboard = keyboard;

  double _xRest = 0;
  double _yRest = 0;
  Map<ControllerButton, void Function()> mapButtons(
          Map<ControllerButton, List<void Function()>> buttonsMapping,
          Map<ControllerButton, List<void Function()>>?
              buttonsMappingNonLocking) =>
      {
        ControllerButton.LEFT_SHOULDER: () {
          _cursor.press(MouseButton.LEFT);
          final leftShoulder = buttonsMapping[ControllerButton.LEFT_SHOULDER]!;
          for (var action in leftShoulder) {
            action();
          }
        },
        ControllerButton.RIGHT_SHOULDER: () => _cursor.press(MouseButton.RIGHT),
        ControllerButton.LEFT_THUMB: () => _cursor.press(MouseButton.WHEEL)
      };

  Map<VariableControllerKey, void Function(int)> mapThumbs(
    Map<VariableControllerKey, List<void Function(int)>> variableKeysMapping,
    Map<VariableControllerKey, List<void Function(int)>>?
        variableKeysMappingNonLocking,
  ) =>
      {
        VariableControllerKey.THUMB_LX: (tx) {
          if (!lock) {
            final cursorPosition = CursorPosition.fromCurrentPosition();
            double x = cursorPosition.x.toDouble() + _xRest;
            final y = cursorPosition.y + _yRest;

            final double lengthsq = (tx * tx).toDouble();
            double dx = 0;
            if (lengthsq > deadzone * deadzone) {
              final mult = cursorSensitivity *
                  ControllerUtils.getMult(lengthsq, deadzone);
              dx = ControllerUtils.getDelta(tx) * mult;
            }
            x += dx;
            _xRest = x - x.toInt();

            _cursor.setCursorPos(CursorPosition(x.toInt(), y.toInt()));
          }

          final thumbLx = variableKeysMapping[VariableControllerKey.THUMB_LX]!;
          for (var action in thumbLx) {
            action(tx);
          }
        },
        VariableControllerKey.THUMB_LY: (ty) {
          if (!lock) {
            final cursorPosition = CursorPosition.fromCurrentPosition();
            final x = cursorPosition.x + _xRest;
            double y = cursorPosition.y.toDouble();

            final double lengthsq = (ty * ty).toDouble();
            double dy = 0;
            if (lengthsq > deadzone * deadzone) {
              final mult = cursorSensitivity *
                  ControllerUtils.getMult(lengthsq, deadzone);
              dy = ControllerUtils.getDelta(ty) * mult;
            }
            y -= dy;
            _yRest = y - y.toInt();

            _cursor.setCursorPos(CursorPosition(x.toInt(), y.toInt()));
          }

          final thumbLy = variableKeysMapping[VariableControllerKey.THUMB_LY]!;
          for (var action in thumbLy) {
            action(ty);
          }
        },
        VariableControllerKey.THUMB_RX: (rx) {
          if (!lock) {
            _cursor.setForce(100, MouseAxis.X, MouseVariableButton.WHEEL);
          }

          final thumbRx = variableKeysMapping[VariableControllerKey.THUMB_RX]!;
          for (var action in thumbRx) {
            action(rx);
          }
        },
        VariableControllerKey.THUMB_RY: (ry) {
          if (!lock) {
            _cursor.setForce(100, MouseAxis.Y, MouseVariableButton.WHEEL);
          }

          final thumbRy = variableKeysMapping[VariableControllerKey.THUMB_RY]!;
          for (var action in thumbRy) {
            action(ry);
          }
        },
      };
}
