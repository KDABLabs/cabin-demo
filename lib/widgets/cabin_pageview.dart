import 'package:flutter/material.dart';

class CabinAppPageView extends StatefulWidget {
  const CabinAppPageView({
    super.key,
    required this.notifier,
    required this.pageController,
    required this.children,
  });

  final ValueNotifier<double> notifier;
  final PageController pageController;
  final List<Widget> children;

  @override
  CabinAppPageViewState createState() => CabinAppPageViewState();
}

class CabinAppPageViewState extends State<CabinAppPageView> {
  void _onScroll() {
    widget.notifier.value = widget.pageController.page!;
  }

  @override
  void initState() {
    widget.pageController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: widget.pageController,
      children: widget.children,
    );
  }
}
