import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:virtual_cursor/virtual_cursor.dart';
import 'package:virtual_keyboard/virtual_keyboard.dart';
import 'package:xinput_gamepad/xinput_gamepad.dart';

class ControllersManagerNotifier extends ChangeNotifier {
  final ControllersManager controllers;
  final Cursor _cursor;
  final Keyboard _keyboard;

  final double cursorSensitivity;
  final double deadzone = 6000;
  final double maxShort = 32767;

  double getMult(double lengthsq, double deadzone, {double accel = 0}) {
    // Normalize the thumbstick value.
    double mult = (sqrt(lengthsq) - deadzone) / (maxShort - deadzone);

    // Apply a curve to the normalized thumbstick value.
    if (accel > 0.0001) {
      mult = pow(mult, accel).toDouble();
    }
    return mult / 150;
  }

  double getDelta(int t) {
    if (t > 32767) t = 0;
    if (t < -32768) t = 0;

    return t.toDouble();
  }

  ControllersManagerNotifier(
      {required this.controllers, this.cursorSensitivity = 0.2})
      : _cursor = Cursor(),
        _keyboard = Keyboard();

  double _xRest = 0;
  double _yRest = 0;
  void mapControllersButton() {
    final buttonsMapping = {
      ControllerButton.LEFT_SHOULDER: () => _cursor.press(MouseButton.LEFT),
      ControllerButton.RIGHT_SHOULDER: () => _cursor.press(MouseButton.RIGHT),
      ControllerButton.LEFT_THUMB: () => _cursor.press(MouseButton.WHEEL)
    };
    final variableKeysMapping = <VariableControllerKey, void Function(int)>{
      VariableControllerKey.THUMB_LX: (tx) {
        final cursorPosition = CursorPosition.fromCurrentPosition();
        double x = cursorPosition.x.toDouble() + _xRest;
        final y = cursorPosition.y + _yRest;

        final double lengthsq = (tx * tx).toDouble();
        double dx = 0;
        if (lengthsq > deadzone * deadzone) {
          final mult = cursorSensitivity * getMult(lengthsq, deadzone);
          dx = getDelta(tx) * mult;
        }
        x += dx;
        _xRest = x - x.toInt();

        _cursor.setCursorPos(CursorPosition(x.toInt(), y.toInt()));
      },
      VariableControllerKey.THUMB_LY: (ty) {
        final cursorPosition = CursorPosition.fromCurrentPosition();
        final x = cursorPosition.x + _xRest;
        double y = cursorPosition.y.toDouble();

        final double lengthsq = (ty * ty).toDouble();
        double dy = 0;
        if (lengthsq > deadzone * deadzone) {
          final mult = cursorSensitivity * getMult(lengthsq, deadzone);
          dy = getDelta(ty) * mult;
        }
        y -= dy;
        _yRest = y - y.toInt();

        _cursor.setCursorPos(CursorPosition(x.toInt(), y.toInt()));
      }
    };

    for (var controller in controllers.controllers) {
      controller.buttonsMapping = buttonsMapping;
      controller.variableKeysMapping = variableKeysMapping;
      controller.listen();
    }
  }
}
