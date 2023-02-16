import 'package:cabin_demo/widgets/subset_images.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LightIcon extends StatelessWidget {
  const LightIcon({super.key});

  static const path = 'assets/images/subset/icons/light.png';

  static final original = Offset.zero & const Size(142, 142);
  static const cropped = Rect.fromLTRB(25.0, 15.0, 116.0, 125.0);
  static final align = Alignment(
    2 * (cropped.left - original.left) / (original.width - cropped.width) - 1,
    2 * (cropped.top - original.top) / (original.height - cropped.height) - 1,
  );

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: cropped.width / original.width,
      heightFactor: cropped.height / original.height,
      alignment: align,
      child: Image.asset(path),
    );
  }
}

class TempIcon extends StatelessWidget {
  const TempIcon({super.key});

  static const path = 'assets/images/subset/icons/temp.png';

  static final original = Offset.zero & const Size(142, 142);
  static const cropped = Rect.fromLTRB(15.0, 16.0, 126.0, 127.0);
  static final align = Alignment(
    2 * (cropped.left - original.left) / (original.width - cropped.width) - 1,
    2 * (cropped.top - original.top) / (original.height - cropped.height) - 1,
  );

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: cropped.width / original.width,
      heightFactor: cropped.height / original.height,
      alignment: align,
      child: Image.asset(path),
    );
  }
}

class MediaIcon extends StatelessWidget {
  const MediaIcon({super.key});

  static const path = 'assets/images/subset/icons/media.png';

  static final original = Offset.zero & const Size(142, 142);
  static const cropped = Rect.fromLTRB(19.0, 26.0, 121.0, 120.0);
  static final align = Alignment(
    2 * (cropped.left - original.left) / (original.width - cropped.width) - 1,
    2 * (cropped.top - original.top) / (original.height - cropped.height) - 1,
  );

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: cropped.width / original.width,
      heightFactor: cropped.height / original.height,
      alignment: align,
      child: Image.asset(path),
    );
  }
}

class HousekeepingIcon extends StatelessWidget {
  const HousekeepingIcon({super.key});

  static const path = 'assets/images/subset/icons/housekeeping.png';

  static final original = Offset.zero & const Size(142, 142);
  static const cropped = Rect.fromLTRB(28.0, 14.0, 132.0, 118.0);
  static final align = Alignment(
    2 * (cropped.left - original.left) / (original.width - cropped.width) - 1,
    2 * (cropped.top - original.top) / (original.height - cropped.height) - 1,
  );

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: cropped.width / original.width,
      heightFactor: cropped.height / original.height,
      alignment: align,
      child: Image.asset(path),
    );
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.notifier,
    required this.pageController,
  });

  final ValueNotifier<double> notifier;
  final PageController pageController;

  static const pages = [
    {
      'index': 1,
      'widget': SubsetImage(data: SubsetImages.lightingIcon),
    },
    {
      'index': 2,
      'widget': SubsetImage(data: SubsetImages.temperatureIcon),
    },
    {
      'index': 3,
      'widget': SubsetImage(data: SubsetImages.mediaIcon),
    },
    {
      'index': 4,
      'widget': SubsetImage(data: SubsetImages.housekeepingIcon),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final page in pages)
            _PageIndicatorButton(
              pageListenable: notifier,
              pageNumber: page['index'] as int,
              icon: page['widget'] as Widget,
              pageController: pageController,
            ),
        ],
      ),
    );
  }
}

class _PageIndicatorButton extends StatelessWidget {
  const _PageIndicatorButton({
    // ignore: unused_element
    super.key,
    required this.pageListenable,
    required this.pageNumber,
    required this.icon,
    required this.pageController,
  });

  final ValueListenable<double> pageListenable;
  final int pageNumber;
  final Widget icon;
  final PageController pageController;

  void animateToPage() {
    pageController.animateToPage(
      pageNumber,
      duration: _duration,
      curve: Curves.ease,
    );
  }

  static const _width = 43.0;
  static const _height = 43.0;
  static const _activeScale = 1.5;
  static const _inactiveScale = 1.0;
  static const _duration = Duration(milliseconds: 250);
  static const _curve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: TextButton(
        onPressed: animateToPage,
        child: SizedBox(
          width: _width,
          height: _height * 1.2,
          child: ValueListenableBuilder<double>(
            valueListenable: pageListenable,
            builder: (context, page, child) {
              final active = page.round() == pageNumber;

              return AnimatedScale(
                scale: active ? _activeScale : _inactiveScale,
                duration: _duration,
                curve: _curve,
                child: child,
              );
            },
            child: FractionallySizedBox(
              widthFactor: 1.2,
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}
