import 'dart:math' as math;
import 'package:cabin_demo/widgets/subset_images.dart';
import 'package:flutter/material.dart';

import 'package:cabin_demo/widgets/widgets.dart';

class ClimatePage extends StatefulWidget {
  const ClimatePage({super.key});

  @override
  ClimatePageState createState() => ClimatePageState();
}

class ClimatePageState extends State<ClimatePage> {
  late double sliderValue;
  late bool switchValue;

  @override
  void initState() {
    sliderValue = 20;
    switchValue = false;
    super.initState();
  }

  void changeSwitchValue(bool value) {
    setState(() {
      switchValue = value;
    });
  }

  void setSliderValue(double value) {
    setState(() {
      sliderValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CabinPageScaffold(
      title: 'Climate',
      index: 1,
      background: const SubsetImage(data: SubsetImages.climateBackground),
      switchWidget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: CabinSwitch(
          value: switchValue,
          onToggle: changeSwitchValue,
        ),
      ),
      positioning: SwitchPositioning.left,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _TemperatureSlider(
            value: sliderValue,
            onChanged: setSliderValue,
          ),
        ),
      ),
    );
  }
}

class _TemperatureSlider extends StatelessWidget {
  const _TemperatureSlider({
    // ignore: unused_element
    super.key,
    required this.value,
    required this.onChanged,
  });

  final double value;
  final double minDegrees = 30;
  final double maxDegrees = -30;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 172,
            height: 376,
            child: Stack(
              children: [
                const Positioned.fill(
                  child: SubsetImage(
                    data: SubsetImages.temperatureSlider,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 70 - 12,
                      left: 30,
                      right: 30,
                    ),
                    child: VerticalSlider(
                      upperValue: 30,
                      lowerValue: -30,
                      onChanged: onChanged,
                      value: value,
                      thumb: Container(
                        margin: const EdgeInsets.only(
                          top: 12,
                          bottom: 12,
                        ),
                        width: 50,
                        height: 50,
                        decoration: const ShapeDecoration(
                          color: Colors.white70,
                          shape: CircleBorder(
                            side: BorderSide(
                              width: 4,
                              color: Color.fromARGB(255, 66, 133, 245),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${value.toStringAsFixed(2)} °C',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class VerticalSlider extends StatelessWidget {
  VerticalSlider({
    super.key,
    this.lowerValue = 1.0,
    this.upperValue = 0.0,
    required this.thumb,
    required this.value,
    required this.onChanged,
  });

  final double lowerValue;
  final double upperValue;
  final Widget thumb;
  final double value;
  final ValueChanged<double> onChanged;

  late final max = math.max(lowerValue, upperValue);
  late final min = math.min(lowerValue, upperValue);

  double _unlerp([double? value]) {
    return ((value ?? this.value) - min) / (max - min);
  }

  double _lerp(double t) {
    return t * (max - min) + min;
  }

  double _tForLocalPosition(BuildContext context, Offset localPosition) {
    final box = context.findRenderObject()! as RenderBox;
    final t = 1.0 - math.max<double>(math.min<double>(localPosition.dy / box.size.height, 1.0), 0.0);
    return t;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragStart: (details) {
          onChanged(_lerp(_tForLocalPosition(context, details.localPosition)));
        },
        onVerticalDragUpdate: (details) {
          onChanged(_lerp(_tForLocalPosition(context, details.localPosition)));
        },
        onTapDown: (details) {
          onChanged(_lerp(_tForLocalPosition(context, details.localPosition)));
        },
        child: Align(
          alignment: Alignment.lerp(Alignment.bottomCenter, Alignment.topCenter, _unlerp())!,
          child: thumb,
        ),
      ),
    );
  }
}
