import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class CabinSwitch extends StatelessWidget {
  const CabinSwitch({
    super.key,
    required this.value,
    required this.onToggle,
    this.showOnOff = true,
  });

  final bool value;
  final ValueChanged<bool> onToggle;
  final bool showOnOff;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 50,
      child: FlutterSwitch(
        switchBorder: Border.all(
          color: const Color.fromARGB(255, 12, 94, 230),
          width: 2,
        ),
        toggleBorder: Border.all(
          color: const Color.fromARGB(255, 12, 94, 230),
          width: 2,
        ),
        width: 100.0,
        height: 50.0,
        valueFontSize: 12.0,
        toggleSize: 40.0,
        value: value,
        activeTextFontWeight: FontWeight.normal,
        inactiveTextFontWeight: FontWeight.normal,
        activeTextColor: Colors.black,
        inactiveTextColor: Colors.black,
        borderRadius: 60.0,
        activeToggleColor: const Color.fromARGB(255, 225, 234, 247),
        activeColor: Colors.white,
        inactiveColor: const Color.fromARGB(255, 225, 234, 247),
        showOnOff: showOnOff,
        onToggle: onToggle,
      ),
    );
  }
}
