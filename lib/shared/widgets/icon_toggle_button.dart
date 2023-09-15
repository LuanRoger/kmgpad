import 'package:fluent_ui/fluent_ui.dart';

class IconToggleButton extends StatelessWidget {
  final Widget pressedIcon;
  final Widget unpressedIcon;
  final void Function(bool) onChanged;
  final bool _pressed;

  const IconToggleButton({
    super.key,
    required this.pressedIcon,
    required this.unpressedIcon,
    required this.onChanged,
    required bool pressed,
  }) : _pressed = pressed;
  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: () => onChanged(!_pressed),
      child: Align(
        alignment: Alignment.center,
        child: _pressed ? pressedIcon : unpressedIcon,
      ),
    );
  }
}
