import 'package:cabin_demo/widgets/subset_images.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cabin_demo/widgets/widgets.dart';

class TopRow extends StatelessWidget {
  const TopRow({
    super.key,
    required this.cabinName,
    required this.pageController,
    required this.pageListenable,
  });

  final String cabinName;
  final PageController pageController;
  final ValueListenable<double> pageListenable;

  void jumpToHomepage() {
    pageController.animateToPage(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RepaintBoundary(
          child: TextButton(
            onPressed: jumpToHomepage,
            child: CabinTopBar(cabinName: cabinName),
          ),
        ),
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.topRight,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                _PageIcons(
                  notifier: pageListenable as ValueNotifier<double>,
                  pageController: pageController,
                ),
                _KdabLogo(pageListenable: pageListenable),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.cabinName,
    required this.pageController,
    required this.pageListenable,
  });

  final String cabinName;
  final PageController pageController;
  final ValueListenable<double> pageListenable;

  static const iconModel = [
    {'name': 'light', 'text': 'Lighting', 'icon': SubsetImage(data: SubsetImages.lightingIcon)},
    {'name': 'temp', 'text': 'Climate', 'icon': SubsetImage(data: SubsetImages.temperatureIcon)},
    {'name': 'media', 'text': 'Media', 'icon': SubsetImage(data: SubsetImages.mediaIcon)},
    {'name': 'ceal', 'text': 'Housekeeping', 'icon': SubsetImage(data: SubsetImages.housekeepingIcon)}
  ];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ValueNotifier<Offset> offsetNotifier;
  static const rollDownDuration = Duration(milliseconds: 350);
  static const rollDownCurve = Curves.easeOut;

  @override
  void initState() {
    widget.pageListenable.addListener(onPageChanged);
    offsetNotifier = ValueNotifier<Offset>(offsetForPage(widget.pageListenable.value));
    super.initState();
  }

  @override
  void dispose() {
    widget.pageListenable.removeListener(onPageChanged);
    super.dispose();
  }

  /// Returns the relative Offset of the Main Page, given current (fractional) page of the PageView.
  /// Main Page starts to scroll in if page < 0.5, starts to scroll out if page > 0.5.
  Offset offsetForPage(double page) {
    if (page < 0.5) {
      return Offset.zero;
    } else {
      return const Offset(0, -1);
    }
  }

  void onPagePressed(int page) {
    widget.pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
    );
  }

  void onPageChanged() {
    offsetNotifier.value = offsetForPage(widget.pageListenable.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(66, 133, 245, 1),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder<Offset>(
              valueListenable: offsetNotifier,
              builder: (context, offset, child) {
                return AnimatedSlide(
                  offset: offset,
                  duration: rollDownDuration,
                  curve: rollDownCurve,
                  child: child,
                );
              },
              child: Column(
                children: [
                  Expanded(
                    child: ColoredBox(
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 127.0),
                            Expanded(
                              child: _PageNavigationButtons(onPagePressed: onPagePressed),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: _HomePageWave(),
                  ),
                ],
              ),
            ),
          ),
          BottomScrollingText(pageListenable: widget.pageListenable),
        ],
      ),
    );
  }
}

class _HomePageWave extends StatelessWidget {
  const _HomePageWave({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _HomePageWavePainter(),
      ),
    );
  }
}

class _HomePageWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;

    final box = Offset.zero & size;
    final rectangle = const Alignment(0.6, 0).inscribe(Size(height, height), box);

    final paint = Paint()
      ..color = const Color(0xFF0C5EE6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    /// TODO: Improve this (use Vertices maybe)

    final linePath = Path()
      ..moveTo(box.bottomLeft.dx, box.bottomLeft.dy)
      ..lineTo(rectangle.bottomLeft.dx, rectangle.bottomLeft.dy)
      ..lineTo(rectangle.topRight.dx, rectangle.topRight.dy)
      ..lineTo(box.topRight.dx, box.topRight.dy);

    final clipPath = Path()
      ..addPath(linePath, Offset.zero)
      ..lineTo(box.topLeft.dx, box.topLeft.dy)
      ..lineTo(box.bottomLeft.dx, box.bottomLeft.dy);

    canvas.save();
    canvas.clipPath(clipPath);
    canvas.drawRect(box, Paint()..color = Colors.white);
    canvas.restore();

    canvas.drawPath(linePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _PageNavigationButtons extends StatelessWidget {
  const _PageNavigationButtons({
    // ignore: unused_element
    super.key,
    required this.onPagePressed,
  });

  final ValueChanged<int> onPagePressed;

  Size constrainForAspectRatio(double aspectRatio, BoxConstraints constraints) {
    final biggest = constraints.biggest;

    if (biggest.width / aspectRatio > biggest.height) {
      return Size(biggest.height * aspectRatio, biggest.height);
    } else {
      return Size(biggest.width, biggest.width / aspectRatio);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // We have 2 layout modes:
        // 4 menu buttons in a row,
        // 2 menu buttons per row and 2 rows.

        // We try to find which one fits best to the constraints.
        // (Covers the most pixels of the available area)

        var buttons = <Widget>[
          for (final entry in HomePage.iconModel.asMap().entries)
            _PageNavigationButton(
              text: entry.value['text'] as String,
              icon: entry.value['icon'] as Widget,
              onPressed: () => onPagePressed(entry.key + 1),
            ),
        ];

        final fourInARow = constrainForAspectRatio(4 / 1, constraints);
        final fourInARowArea = fourInARow.width * fourInARow.height;

        final twoByTwo = constrainForAspectRatio(2 / 2, constraints);
        final twoByTwoArea = twoByTwo.width * twoByTwo.height;

        if (twoByTwoArea >= fourInARowArea) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final row in [buttons.take(2), buttons.skip(2).take(2)])
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (final button in row) Flexible(child: button),
                    ],
                  ),
                ),
            ],
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (final button in buttons) Flexible(child: button),
              ],
            ),
          );
        }
      },
    );
  }
}

class _PageNavigationButton extends StatefulWidget {
  const _PageNavigationButton({
    // ignore: unused_element
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  final String text;
  final Widget icon;
  final Function onPressed;

  @override
  _PageNavigationButtonState createState() => _PageNavigationButtonState();
}

class _PageNavigationButtonState extends State<_PageNavigationButton> {
  static const _activeScale = 1.3;
  static const _inactiveScale = 1.1;

  final scaleNotifier = ValueNotifier<double>(_inactiveScale);

  @override
  void dispose() {
    scaleNotifier.dispose();
    super.dispose();
  }

  void setScale(double scale) {
    scaleNotifier.value = scale;
  }

  void setActive([bool active = true]) {
    scaleNotifier.value = active ? _activeScale : _inactiveScale;
  }

  void setInactive() {
    setActive(false);
  }

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF4285F5);

    return RepaintBoundary(
      child: TextButton(
        onPressed: () {
          setInactive();
          widget.onPressed();
        },
        onHover: setActive,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ValueListenableBuilder<double>(
                valueListenable: scaleNotifier,
                builder: (context, scale, child) {
                  return AnimatedScale(
                    curve: Curves.decelerate,
                    scale: scale,
                    duration: const Duration(milliseconds: 100),
                    child: child,
                  );
                },
                child: widget.icon,
              ),
            ),
            Text(
              widget.text,
              style: const TextStyle(
                fontSize: 18,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageIcons extends StatelessWidget {
  const _PageIcons({
    // ignore: unused_element
    super.key,
    required ValueNotifier<double> notifier,
    required PageController pageController,
  })  : _notifier = notifier,
        _pageController = pageController;

  final ValueNotifier<double> _notifier;
  final PageController _pageController;

  static const slideDuration = Duration(milliseconds: 350);
  static const slideCurve = Curves.easeOut;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _notifier,
      builder: (context, value, child) {
        final visible = _notifier.value.round() != 0;

        return AnimatedSlide(
          offset: Offset(visible ? 0.0 : 1.0, 0),
          duration: slideDuration,
          curve: slideCurve,
          child: child,
        );
      },
      child: PageIndicator(
        notifier: _notifier,
        pageController: _pageController,
      ),
    );
  }
}

class _KdabLogo extends StatelessWidget {
  const _KdabLogo({
    // ignore: unused_element
    super.key,
    required this.pageListenable,
  });

  static const slideDuration = Duration(milliseconds: 400);
  final ValueListenable<double> pageListenable;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: pageListenable,
      builder: (context, value, child) {
        final active = value < 0.5;

        return AnimatedSlide(
          offset: Offset(active ? 0.0 : 1.0, 0.0),
          duration: slideDuration,
          curve: Curves.easeOutCubic,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                  children: const [
                    TextSpan(
                      text: 'Get in touch with KDAB here:\n',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      children: [
                        WidgetSpan(child: SizedBox(width: 20)),
                        TextSpan(text: 'https://kdab.com\n'),
                        WidgetSpan(child: SizedBox(width: 20)),
                        TextSpan(text: 'info@kdab.com'),
                      ],
                      style: TextStyle(
                        color: Color(0xFF616161), // Colors.grey.shade700
                      ),
                    )
                  ],
                  style: DefaultTextStyle.of(context).style,
                ),
              ),
              const Padding(padding: EdgeInsets.only(right: 24)),
              const Opacity(
                opacity: 0.9,
                child: SubsetImage(
                  data: SubsetImages.logo,
                  width: 180,
                  height: 127,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
