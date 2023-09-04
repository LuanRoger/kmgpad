import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';

class ThumbstickView extends StatelessWidget {
  final int x;
  final int y;
  const ThumbstickView({super.key, required this.x, required this.y});

  @override
  Widget build(BuildContext context) {
    final themeMode =
        context.findAncestorWidgetOfExactType<FluentApp>()?.themeMode;
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: ThumbstickPainter(
        x,
        y,
        backgroundColor:
            themeMode == ThemeMode.light ? Colors.grey[20] : Colors.grey[160],
      ),
    );
  }
}

class ThumbstickPainter extends CustomPainter {
  final int x;
  final int y;
  final Color? boundingBoxColor;
  final Color? thumbstickPositionColor;
  final Color? backgroundColor;

  ThumbstickPainter(
    this.x,
    this.y, {
    this.boundingBoxColor,
    this.thumbstickPositionColor,
    this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final minSize = min(size.width, size.height);
    final border = minSize / 10;
    final boxLength = minSize - border * 2;

    // Range of thumbsticks is -32768 <= x <= 32767. We rescale the values to
    // fit in the bounding box.
    final offset = Offset(((x + 32768) / 65535 * boxLength) + border,
        (boxLength - (y + 32768) / 65535 * boxLength) + border);

    final boundingCircle = Paint()
      ..strokeWidth = border / 6
      ..color = backgroundColor ?? Colors.grey[20]
      ..style = PaintingStyle.stroke;
    final positionPaint = Paint()
      ..color = thumbstickPositionColor ?? Colors.blue
      ..strokeWidth = border / 4
      ..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..color = thumbstickPositionColor ?? Colors.grey[20]
      ..strokeWidth = border / 20
      ..style = PaintingStyle.stroke;

    canvas
      ..drawCircle(
        rect.center,
        minSize / 2,
        boundingCircle,
      )
      ..drawLine(
        rect.center,
        offset,
        linePaint,
      )
      ..drawCircle(
        offset,
        border / 4,
        positionPaint,
      );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
