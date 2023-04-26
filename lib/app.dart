import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:desktop_window/desktop_window.dart';
import 'package:cabin_demo/pages/pages.dart';
import 'package:cabin_demo/widgets/widgets.dart';

/// Needed to be able to horizontal-scroll the pages with a mouse.
/// PageView scrolling doesn't work that well with the normal desktop Shift+MouseWheel scrolling.
class AnyPointerDeviceCanScrollBehaviour extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => PointerDeviceKind.values.toSet();
}

class CabinDemoApp extends StatelessWidget {
  const CabinDemoApp({
    super.key,
    required this.enableWindowSizeSwitcherIfPossible,
  });

  final bool enableWindowSizeSwitcherIfPossible;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: AnyPointerDeviceCanScrollBehaviour(),
      home: CabinDemoMainPage(
        enableWindowSizeSwitcherIfPossible: enableWindowSizeSwitcherIfPossible,
      ),
    );
  }
}

class CabinDemoMainPage extends StatefulWidget {
  const CabinDemoMainPage({
    super.key,
    this.cabinName = 'Cabin12250',
    this.enableWindowSizeSwitcherIfPossible = false,
  });

  final String cabinName;
  final bool enableWindowSizeSwitcherIfPossible;

  @override
  State<CabinDemoMainPage> createState() => _CabinDemoMainPageState();
}

@immutable
class WindowSizeSetting {
  const WindowSizeSetting({
    this.debugLabel,
    required this.size,
    required this.icon,
  });

  final String? debugLabel;
  final Widget icon;
  final Size size;
}

class _CabinDemoMainPageState extends State<CabinDemoMainPage> {
  late final PageController pageController;
  late final ValueNotifier<double> pageNotifier;
  late final Future<bool> desktopWindowPluginPresent;

  static const raspberryPiLogo =
      'https://upload.wikimedia.org/wikipedia/de/thumb/c/cb/Raspberry_Pi_Logo.svg/1200px-Raspberry_Pi_Logo.svg.png';

  static const _pageTransitionDuration = Duration(milliseconds: 350);
  static const _pageTransitionCurve = Curves.ease;

  static final _windowSizes = [
    WindowSizeSetting(
      debugLabel: 'Raspberry Pi 7" Touchscreen',
      icon: Image.network(raspberryPiLogo),
      size: const Size(515, 824),
    ),
    const WindowSizeSetting(
      debugLabel: 'Datamodul Display',
      icon: Text('i.MX'),
      size: Size(800, 480),
    ),
  ];

  @override
  void initState() {
    super.initState();
    pageNotifier = ValueNotifier<double>(0);
    pageController = PageController();
    desktopWindowPluginPresent = DesktopWindow.getWindowSize().then(
      (_) => true,
      onError: (_, __) => false,
    );

    desktopWindowPluginPresent.then((present) {
      debugPrint('desktop window plugin present: $present');
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageNotifier.dispose();
    pageController.dispose();
  }

  void jumpToHomepage() {
    pageController.animateToPage(
      0,
      duration: _pageTransitionDuration,
      curve: _pageTransitionCurve,
    );
  }

  void onPagePressed(int page) {
    assert(0 <= page && page <= 5);
    pageController.animateToPage(
      page,
      duration: _pageTransitionDuration,
      curve: _pageTransitionCurve,
    );
  }

  Widget buildWindowSizeSwitcher() {
    return FutureBuilder(
      future: desktopWindowPluginPresent,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              for (final setting in _windowSizes)
                FloatingActionButton(
                  onPressed: () => DesktopWindow.setWindowSize(setting.size),
                  child: setting.icon,
                ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: ColoredBox(
        color: const Color.fromRGBO(66, 133, 245, 1),
        child: Stack(
          children: [
            CabinAppPageView(
              notifier: pageNotifier,
              pageController: pageController,
              children: [
                HomePage(
                  cabinName: widget.cabinName,
                  pageController: pageController,
                  pageListenable: pageNotifier,
                ),
                const LightingPage(),
                const ClimatePage(),
                const MediaPage(),
                const HousekeepingPage(),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: TopRow(
                cabinName: widget.cabinName,
                pageListenable: pageNotifier,
                pageController: pageController,
              ),
            ),
            if (widget.enableWindowSizeSwitcherIfPossible)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: buildWindowSizeSwitcher(),
              )
          ],
        ),
      ),
    );
  }
}
