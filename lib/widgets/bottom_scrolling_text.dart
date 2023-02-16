import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class BottomScrollingText extends StatefulWidget {
  const BottomScrollingText({
    super.key,
    required this.pageListenable,
  });

  final ValueListenable<double> pageListenable;

  static final _marqueeText = [
    ' Welcome Mr . Alexander Lindel',
    'Tonight! Try the brazed scallops at the 5 season restaurant!',
    'Don\'t miss on the opportunity to fly in our explorer experience in the upper deck.',
  ].join(' ' * 27);

  @override
  State<BottomScrollingText> createState() => _BottomScrollingTextState();
}

class _BottomScrollingTextState extends State<BottomScrollingText> with TickerProviderStateMixin {
  late final controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  late final offsets = Tween<Offset>(
    begin: const Offset(0, 0),
    end: const Offset(0, 1),
  );

  late final animation = offsets.animate(
    CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutCubic,
    ),
  );

  final animationStatusNotifier = ValueNotifier<AnimationStatus>(AnimationStatus.dismissed);

  @override
  void initState() {
    widget.pageListenable.addListener(onPageChanged);
    animation.addStatusListener(onAnimationStatusChanged);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BottomScrollingText oldWidget) {
    if (oldWidget.pageListenable != widget.pageListenable) {
      oldWidget.pageListenable.removeListener(onPageChanged);
      widget.pageListenable.addListener(onPageChanged);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.pageListenable.removeListener(onPageChanged);
    animation.removeStatusListener(onAnimationStatusChanged);
    controller.dispose();
    animationStatusNotifier.dispose();
    super.dispose();
  }

  void onAnimationStatusChanged(AnimationStatus status) {
    animationStatusNotifier.value = status;
  }

  void onPageChanged() {
    if (widget.pageListenable.value <= 0.5 &&
        controller.status != AnimationStatus.reverse &&
        controller.status != AnimationStatus.dismissed) {
      controller.reverse();
    }

    if (widget.pageListenable.value > 0.5 &&
        controller.status != AnimationStatus.forward &&
        controller.status != AnimationStatus.completed) {
      controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: animationStatusNotifier,
      builder: (context, status, child) {
        return TickerMode(
          enabled: status != AnimationStatus.completed,
          child: child!,
        );
      },
      child: SlideTransition(
        position: animation,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 36),
          child: SizedBox(
            height: 30,
            child: Marquee(
              text: BottomScrollingText._marqueeText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
              scrollAxis: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              blankSpace: 20.0,
              velocity: 20.0,
              pauseAfterRound: const Duration(seconds: 1),
              startPadding: 10.0,
              showFadingOnlyWhenScrolling: true,
              fadingEdgeStartFraction: 0.2,
              fadingEdgeEndFraction: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}
