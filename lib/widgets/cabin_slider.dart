import 'package:flutter/material.dart';

class CabinSlider extends StatelessWidget {
  const CabinSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 50,
      child: Material(
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 50,
            trackShape: CabinSliderTrackShape(),
            activeTrackColor: const Color.fromARGB(255, 225, 234, 247),
            inactiveTrackColor: const Color.fromARGB(255, 225, 234, 247),
            thumbColor: Colors.white,
            thumbShape: const CabinSliderThumbShape(thumbRadius: 21),
          ),
          child: Slider(
            value: value,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}

class CabinSliderThumbShape extends SliderComponentShape {
  final double thumbRadius;

  const CabinSliderThumbShape({
    required this.thumbRadius,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final fillPaint = Paint()
      ..color = sliderTheme.thumbColor!
      ..style = PaintingStyle.fill;

    const borderColor = Color.fromARGB(255, 12, 94, 230);

    final rect = Rect.fromCircle(center: center, radius: thumbRadius);

    const border = CircleBorder(side: BorderSide(color: borderColor, width: 2));

    border.paint(context.canvas, rect);
    context.canvas.drawPath(border.getInnerPath(rect), fillPaint);
  }
}

class CabinSliderTrackShape extends SliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = true,
    bool isDiscrete = false,
  }) {
    final thumbSize = sliderTheme.thumbShape!.getPreferredSize(isEnabled, isDiscrete);
    const insidePadding = 4;
    final inscribedSize = (parentBox.size - Offset(thumbSize.width + 2 * insidePadding, 0)) as Size;
    return Alignment.center.inscribe(inscribedSize, Offset.zero & parentBox.size);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    Offset? secondaryOffset,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = true,
  }) {
    final fillPaint = Paint()
      ..color = sliderTheme.activeTrackColor!
      ..style = PaintingStyle.fill;

    const borderColor = Color.fromARGB(255, 12, 94, 230);

    const border = StadiumBorder(
      side: BorderSide(width: 2, color: borderColor),
    );

    final rect = offset & parentBox.size;

    context.canvas.drawPath(border.getInnerPath(rect), fillPaint);
    border.paint(context.canvas, rect);
  }
}
