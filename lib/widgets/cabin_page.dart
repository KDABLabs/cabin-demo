import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

enum SwitchPositioning {
  right(false, false),
  left(true, false),
  tallRight(false, true),
  tallLeft(true, true);

  const SwitchPositioning(this.isLeft, this.isTall)
      : isRight = !isLeft,
        isSmall = !isTall;

  final bool isLeft;
  final bool isRight;
  final bool isTall;
  final bool isSmall;
}

enum CabinPageLayout {
  firstPage(SwitchPositioning.right),
  secondPage(SwitchPositioning.left),
  thirdPage(SwitchPositioning.tallRight),
  fourthPage(SwitchPositioning.tallLeft);

  const CabinPageLayout(this.switchPositioning);

  final SwitchPositioning switchPositioning;
}

class CabinPageScaffold extends StatelessWidget {
  const CabinPageScaffold({
    super.key,
    this.title,
    required this.index,
    required this.positioning,
    this.background,
    this.backgroundImagePath,
    this.switchWidget,
    this.body,
  }) : assert((background != null) != (backgroundImagePath != null));

  final int index;
  final String? title;
  final Widget? switchWidget;
  final SwitchPositioning positioning;
  final Widget? body;
  final Widget? background;
  final String? backgroundImagePath;

  static const _largeSwitchHeight = 178.0;
  static const _smallSwitchHeight = 103.0;
  static const _waveHeight = 493.0;
  static const _titleOffsetLarge = 370.0;
  static const _titleOffsetSmall = 290.0;
  static const _switchOffset = 169.0;

  @override
  Widget build(BuildContext context) {
    final isTall = positioning.isTall;
    final isLeft = positioning.isLeft;

    /// TODO: Improve the layouting here

    // This is the fixed size of the page in the original Qt template.
    // Since we want to match the template as closely as possible,
    // we measure the offsets & widths from the template and scale them up to our
    // canvas size.
    const page = Rect.fromLTWH(0, 0, 480, 800);

    late final Rect bodySemiSafe = Alignment.bottomCenter.inscribe(const Size(480, 800 - 172), page);
    late final Rect bodySafe;
    if (isTall) {
      bodySafe = Alignment.bottomCenter.inscribe(const Size(480, 800 - 350 - 172), page);
    } else {
      bodySafe = Alignment.bottomCenter.inscribe(const Size(480, 800 - 275 - 172), page);
    }

    // ignore: unused_local_variable
    final bodySemiSafeHeightFactor = bodySemiSafe.height / page.height;
    final bodySafeHeightFactor = bodySafe.height / bodySemiSafe.height;

    late final Alignment switchAlignment;
    late final Rect switchSemiSafe;
    late final Rect switchSafe;
    if (!isLeft && !isTall) {
      switchAlignment = Alignment.topRight;
      switchSemiSafe = switchAlignment.inscribe(const Size(480 - 100, _smallSwitchHeight), bodySemiSafe);
      switchSafe = switchAlignment.inscribe(const Size(480 - 205, _smallSwitchHeight), bodySemiSafe);
    } else if (isLeft && !isTall) {
      switchAlignment = Alignment.topLeft;
      switchSemiSafe = switchAlignment.inscribe(const Size(211, _smallSwitchHeight), bodySemiSafe);
      switchSafe = switchAlignment.inscribe(const Size(108, _smallSwitchHeight), bodySemiSafe);
    } else if (!isLeft && isTall) {
      switchAlignment = Alignment.topRight;
      switchSemiSafe = switchAlignment.inscribe(const Size(393, _largeSwitchHeight), bodySemiSafe);
      switchSafe = switchAlignment.inscribe(const Size(216, _largeSwitchHeight), bodySemiSafe);
    } else {
      assert(isLeft && isTall);
      switchAlignment = Alignment.topLeft;
      switchSemiSafe = switchAlignment.inscribe(const Size(374, _largeSwitchHeight), bodySemiSafe);
      switchSafe = switchAlignment.inscribe(const Size(196, _largeSwitchHeight), bodySemiSafe);
    }

    final switchSemiSafeWidthFactor = switchSemiSafe.width / page.width;
    final switchSafeWidthFactor = switchSafe.width / switchSemiSafe.width;

    final imageBox = Alignment.center.inscribe(const Size(2 * 480, 800 - 260), page);

    var titleAlignment = Alignment.center;
    if (isLeft) {
      titleAlignment = titleAlignment + Alignment.centerLeft;
    } else {
      titleAlignment = titleAlignment + Alignment.centerRight;
    }

    if (isTall) {
      titleAlignment = titleAlignment + const Alignment(0, _titleOffsetLarge / 350 - 1);
    } else {
      titleAlignment = titleAlignment + const Alignment(0, _titleOffsetSmall / 350 - 1);
    }

    return CabinPageInsets(
      switchAlignment: switchAlignment,
      switchFraction: switchSafeWidthFactor,
      bodyFraction: bodySafeHeightFactor,
      child: Scaffold(
        backgroundColor: const Color(0xFF4285F5),
        body: Stack(
          children: [
            // background image
            Positioned.fill(
              child: Flow(
                delegate: ParallaxFlowDelegate(
                  scrollable: Scrollable.of(context),
                ),
                children: [
                  FractionallySizedBox(
                    heightFactor: imageBox.height / page.height,
                    widthFactor: imageBox.width / page.width,
                    alignment: Alignment.center,
                    child: background != null
                        ? SizedBox(
                            width: double.infinity,
                            child: background!,
                          )
                        : Image.asset(
                            backgroundImagePath!,
                            fit: BoxFit.fitWidth,
                          ),
                  ),
                ],
              ),
            ),
            // optionally, the page title, printed below the switch part of the wave,
            // on the background image
            if (title != null)
              Positioned.fill(
                child: Align(
                  alignment: titleAlignment,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 30, left: 30),
                    child: Text(
                      title!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.275),
                        fontSize: 40,
                      ),
                    ),
                  ),
                ),
              ),
            // the page body
            SizedBox.expand(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  alignment: Alignment.bottomCenter,
                  heightFactor: (800 - 172) / 800,
                  child: body,
                ),
              ),
            ),
            // top of the page wave
            Positioned.fill(
              child: FractionallySizedBox(
                alignment: Alignment.topCenter,
                heightFactor: _waveHeight / 800,
                child: _CabinPageWave(
                  pageIndex: index,
                ),
              ),
            ),
            // switch, painted onto the wave
            Positioned.fill(
              child: FractionallySizedBox(
                widthFactor: switchSemiSafeWidthFactor,
                heightFactor: switchSafe.height / 800,
                alignment: Alignment(
                  switchAlignment.x,
                  _switchOffset / 350 - 1,
                ),
                child: Align(
                  alignment: switchAlignment,
                  child: switchWidget,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CabinPageWave extends StatelessWidget {
  const _CabinPageWave({
    // ignore: unused_element
    super.key,
    required this.pageIndex,
    // ignore: unused_element
    this.widthFactor = 1.0,
    this.useVertices = true,
  });

  static const waveImagePath = 'assets/images/wave.png';

  final int pageIndex;
  final double widthFactor;
  final bool useVertices;

  @override
  Widget build(BuildContext context) {
    final align = Alignment.lerp(
      Alignment.topLeft,
      Alignment.topRight,
      (85 + 480 * pageIndex) / (2375 - 480),
    )!;

    /// TODO: Use a custom painter with Vertices here
    ///

    if (useVertices) {
      return SizedBox.expand(
        child: CustomPaint(
          foregroundPainter: _WavePainter.page(pageIndex),
        ),
      );
    } else {
      return FractionallySizedBox(
        widthFactor: (480 * widthFactor + 1) / 480,
        child: ClipRect(
          clipBehavior: Clip.hardEdge,
          child: IgnorePointer(
            child: FractionallySizedBox(
              widthFactor: 2375 / (480 * widthFactor + 1),
              alignment: align,
              child: Image.asset(
                waveImagePath,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      );
    }
  }
}

class _WavePainter extends CustomPainter {
  _WavePainter.page(int pageIndex)
      : _vertices = _allVertices[pageIndex],
        _path = _allPaths[pageIndex];

  /// TODO: Implement the fadeout of the wave onto the main (home) page.
  static final _allVertices = [
    ui.Vertices(
      VertexMode.triangleStrip,
      const [
        Offset(0, 171),
        Offset(0, 0),
        Offset(91, 171),
        Offset(480, 0),
        Offset(204, 274),
        Offset(480, 274),
      ],
    ),
    ui.Vertices(
      VertexMode.triangleStrip,
      const [
        Offset(480, 274),
        Offset(589, 274),
        Offset(480, 0),
        Offset(692, 171),
        Offset(960, 0),
        Offset(960, 171),
      ].map((off) => off - const Offset(480, 0)).toList(),
    ),
    ui.Vertices(
      VertexMode.triangleStrip,
      const [
        Offset(960, 171),
        Offset(960, 0),
        Offset(1046, 171),
        Offset(1440, 0),
        Offset(1223, 349),
        Offset(1440, 349),
      ].map((off) => off - const Offset(960, 0)).toList(),
    ),
    ui.Vertices(
      VertexMode.triangleStrip,
      const [
        Offset(1440, 349),
        Offset(1637, 349),
        Offset(1440, 0),
        Offset(1815, 171),
        Offset(1920, 0),
        Offset(1920, 171),
      ].map((off) => off - const Offset(1440, 0)).toList(),
    ),
  ];

  static final _allPaths = [
    Path()
      ..moveTo(0, 171)
      ..lineTo(91, 171)
      ..lineTo(204, 274)
      ..lineTo(480, 274),
    Path()
      ..moveTo(0, 274)
      ..lineTo(589 - 480, 274)
      ..lineTo(692 - 480, 171)
      ..lineTo(960, 171),
    Path()
      ..moveTo(0, 171)
      ..lineTo(1046 - 960, 171)
      ..lineTo(1223 - 960, 349)
      ..lineTo(480, 349),
    Path()
      ..moveTo(0, 349)
      ..lineTo(1637 - 1440, 349)
      ..lineTo(1815 - 1440, 171)
      ..lineTo(480, 171)
  ];

  final ui.Vertices _vertices;
  final Path _path;

  @override
  void paint(Canvas canvas, Size size) {
    // to be pixel-perfect, we'd scale the canvas so it's 480x493
    // but that sometimes leaves a hairline of blue between pages
    // so we draw a bit over our bounds here, in x-direction only
    canvas.scale(size.width / 478, size.height / 493);
    canvas.translate(-1, 0);

    canvas.drawVertices(
      _vertices,
      BlendMode.src,
      Paint()..color = Colors.white,
    );
    canvas.drawPath(
      _path,
      Paint()
        ..style = PaintingStyle.stroke
        ..color = const Color(0xFF0C5EE6)
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate._vertices != _vertices || oldDelegate._path != _path;
  }

  @override
  bool? hitTest(ui.Offset position) {
    /// TODO: Implement this by testing whether the position is inside any of the triangles we've drawn.
    return super.hitTest(position);
  }
}

class CabinPageInsets extends InheritedWidget {
  const CabinPageInsets({
    super.key,
    required super.child,
    required this.switchAlignment,
    required this.switchFraction,
    required this.bodyFraction,
  });

  final AlignmentGeometry switchAlignment;
  final double switchFraction;
  final double bodyFraction;

  @override
  bool updateShouldNotify(covariant CabinPageInsets oldWidget) {
    return oldWidget.switchAlignment != switchAlignment ||
        switchFraction != oldWidget.switchFraction ||
        oldWidget.bodyFraction != bodyFraction;
  }

  static CabinPageInsets? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CabinPageInsets>();
  }

  static CabinPageInsets of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CabinPageInsets>()!;
  }
}

abstract class CabinPageSafeArea extends StatelessWidget {
  const factory CabinPageSafeArea.forBody({Key key, required Widget child}) = _CabinPageSafeAreaBody;
  const factory CabinPageSafeArea.forSwitch({Key key, required Widget child}) = _CabinPageSafeAreaSwitch;
}

class _CabinPageSafeAreaBody extends StatelessWidget implements CabinPageSafeArea {
  const _CabinPageSafeAreaBody({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final insets = CabinPageInsets.of(context);
    return FractionallySizedBox(
      alignment: Alignment.bottomCenter,
      heightFactor: insets.bodyFraction,
      child: child,
    );
  }
}

class _CabinPageSafeAreaSwitch extends StatelessWidget implements CabinPageSafeArea {
  const _CabinPageSafeAreaSwitch({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final insets = CabinPageInsets.of(context);
    return FractionallySizedBox(
      alignment: insets.switchAlignment,
      widthFactor: insets.switchFraction,
      child: child,
    );
  }
}

/// [FlowDelegate] which will implement an (actually inverse) parallax effect.
/// Will draw the child of the [Flow] widget at double the offset from the center of the Scrollable.
class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate({required this.scrollable}) : super(repaint: scrollable.position);

  final ScrollableState scrollable;

  @override
  void paintChildren(FlowPaintingContext context) {
    final box = context as RenderFlow;
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;

    final centerInScrollable = box.localToGlobal(
      box.size.center(Offset.zero),
      ancestor: scrollableBox,
    );

    final centerLeftInScrollable = box.localToGlobal(
      box.size.centerLeft(Offset.zero),
      ancestor: scrollableBox,
    );

    final virtualViewBox = Rect.fromCenter(
      center: centerInScrollable,
      width: box.size.width * 2,
      height: box.size.height * 2,
    );

    final inscribed = Alignment(
      centerLeftInScrollable.dx / scrollable.position.viewportDimension,
      0,
    ).inscribe(box.size, virtualViewBox);

    context.paintChild(
      0,
      transform: Matrix4.translationValues(inscribed.left, 0, 0),
    );
  }

  @override
  bool shouldRepaint(covariant ParallaxFlowDelegate oldDelegate) {
    return oldDelegate.scrollable != scrollable;
  }
}
