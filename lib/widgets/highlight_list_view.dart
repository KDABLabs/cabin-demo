import 'dart:math';

import 'package:flutter/material.dart';

class HighlightListView extends StatefulWidget {
  const HighlightListView({
    super.key,
    this.highlightPlacement = Alignment.center,
    this.clip = Clip.hardEdge,
    required this.itemExtent,
    this.forceItemExtent = false,
    required this.children,
  });

  final double itemExtent;
  final Alignment highlightPlacement;
  final Clip clip;
  final bool forceItemExtent;
  final List<Widget> children;

  @override
  State<HighlightListView> createState() => _HighlightListViewState();
}

class _HighlightListViewState extends State<HighlightListView> {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipBehavior: widget.clip,
      child: FractionallySizedBox(
        widthFactor: max(widget.highlightPlacement.x + 1.0, -widget.highlightPlacement.x + 1.0),
        heightFactor: max(widget.highlightPlacement.y + 1.0, -widget.highlightPlacement.y + 1.0),
        alignment: Alignment(
          widget.highlightPlacement.x > 0 ? -1 : 1,
          widget.highlightPlacement.y > 0 ? -1 : 1,
        ),
        child: ShaderMask(
          blendMode: BlendMode.modulate,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withAlpha(0),
                Colors.white.withAlpha(255),
                Colors.white.withAlpha(255),
                Colors.white.withAlpha(0),
              ],
              stops: const [
                0.0,
                0.33,
                0.66,
                1.0,
              ],
            ).createShader(bounds);
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: widget.itemExtent,
                    decoration: const ShapeDecoration(
                      shape: StadiumBorder(side: BorderSide(color: Colors.white, width: 5)),
                    ),
                  ),
                ),
              ),
              ListWheelScrollView(
                diameterRatio: 100,
                physics: const FixedExtentScrollPhysics(),
                itemExtent: widget.itemExtent,
                overAndUnderCenterOpacity: 0.5,
                children: widget.forceItemExtent
                    ? [
                        for (final item in widget.children)
                          SizedBox(
                            height: widget.itemExtent,
                            child: item,
                          ),
                      ]
                    : widget.children,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum IconPlacement { left, right }

class CabinIconOption extends StatelessWidget {
  const CabinIconOption({
    super.key,
    this.icon,
    this.iconPath,
    required this.text,
    required this.iconPlacement,
  }) : assert((icon != null) != (iconPath != null));

  const CabinIconOption.left({
    super.key,
    this.icon,
    this.iconPath,
    required this.text,
  })  : iconPlacement = IconPlacement.left,
        assert((icon != null) != (iconPath != null));

  const CabinIconOption.right({
    super.key,
    this.icon,
    this.iconPath,
    required this.text,
  })  : iconPlacement = IconPlacement.right,
        assert((icon != null) != (iconPath != null));

  final String? iconPath;
  final Widget? icon;
  final String text;
  final IconPlacement iconPlacement;

  @override
  Widget build(BuildContext context) {
    final isLeft = iconPlacement == IconPlacement.left;

    final icon = this.icon != null
        ? SizedBox(width: 140, height: 140, child: this.icon)
        : Image(
            fit: BoxFit.cover,
            width: 140,
            height: 140,
            image: AssetImage(iconPath!),
          );

    return Row(
      mainAxisAlignment: isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        if (isLeft) icon,
        SizedBox(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 40),
            softWrap: true,
            textAlign: isLeft ? TextAlign.start : TextAlign.end,
          ),
        ),
        if (!isLeft) icon
      ],
    );
  }
}
