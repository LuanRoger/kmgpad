import 'dart:math';

class ControllerUtils {
  static const double _maxShort = 32767;

  static double getMult(double lengthsq, double deadzone, {double accel = 0}) {
    double mult = (sqrt(lengthsq) - deadzone) / (_maxShort - deadzone);

    if (accel > 0.0001) {
      mult = pow(mult, accel).toDouble();
    }
    return mult / 150;
  }

  static double getDelta(int t) {
    if (t > 32767) t = 0;
    if (t < -32768) t = 0;

    return t.toDouble();
  }
}
