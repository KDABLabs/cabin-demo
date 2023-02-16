import 'package:cabin_demo/widgets/subset_images.dart';
import 'package:flutter/material.dart';
import 'package:cabin_demo/widgets/widgets.dart';

class LightingPage extends StatefulWidget {
  const LightingPage({super.key});

  @override
  LightingPageState createState() => LightingPageState();
}

class LightingPageState extends State<LightingPage> {
  var switchValue = false;
  var sliderValue = 0.0;

  void setSwitchValue(value) {
    setState(() {
      switchValue = value;
    });
  }

  static const items = [
    {
      'icon': 'assets/images/lightmod.icon.png',
      'text': 'Cleaning',
      'widget': SubsetImage(data: SubsetImages.lightmod0Icon)
    },
    {'icon': 'assets/images/lightmod.icon.png', 'text': 'Red', 'widget': SubsetImage(data: SubsetImages.lightmod0Icon)},
    {
      'icon': 'assets/images/lightmod1.icon.png',
      'text': 'Green',
      'widget': SubsetImage(data: SubsetImages.lightmod1Icon)
    },
    {
      'icon': 'assets/images/lightmod2.icon.png',
      'text': 'Blue',
      'widget': SubsetImage(data: SubsetImages.lightmod2Icon)
    },
    {
      'icon': 'assets/images/lightmod.icon.png',
      'text': 'Normal',
      'widget': SubsetImage(data: SubsetImages.lightmod0Icon)
    },
    {
      'icon': 'assets/images/lightmod1.icon.png',
      'text': 'Candlelight',
      'widget': SubsetImage(data: SubsetImages.lightmod1Icon)
    },
    {
      'icon': 'assets/images/lightmod2.icon.png',
      'text': 'All Off',
      'widget': SubsetImage(data: SubsetImages.lightmod2Icon)
    },
  ];

  Widget stackCrossFadeLayoutBuilder(Widget topChild, Key topChildKey, Widget bottomChild, Key bottomChildKey) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Positioned.fill(
          key: bottomChildKey,
          child: bottomChild,
        ),
        Positioned(
          key: topChildKey,
          child: topChild,
        ),
      ],
    );
  }

  Padding buildLightSwitchView() {
    return Padding(
      padding: const EdgeInsets.only(top: 100, bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 1; i <= 7; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: _LightGroupRow(groupNumber: i),
            ),
        ],
      ),
    );
  }

  Padding buildLightModView() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 30),
      child: HighlightListView(
        highlightPlacement: const Alignment(0.0, 0.45),
        itemExtent: 148,
        children: [
          for (final item in items)
            CabinIconOption.left(
              icon: item['widget'] as Widget,
              text: item['text'] as String,
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CabinPageScaffold(
      title: 'Lighting',
      index: 0,
      background: const SubsetImage(data: SubsetImages.lightingBackground),
      positioning: SwitchPositioning.right,
      switchWidget: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: CabinSwitch(
            showOnOff: false,
            value: switchValue,
            onToggle: setSwitchValue,
          ),
        ),
      ),
      body: AnimatedCrossFade(
        layoutBuilder: stackCrossFadeLayoutBuilder,
        firstChild: buildLightModView(),
        secondChild: buildLightSwitchView(),
        crossFadeState: switchValue ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }
}

class _LightGroupRow extends StatefulWidget {
  const _LightGroupRow({
    // ignore: unused_element
    super.key,
    required this.groupNumber,
  });

  final int groupNumber;

  @override
  _LightGroupRowState createState() => _LightGroupRowState();
}

class _LightGroupRowState extends State<_LightGroupRow> {
  var sliderValue = 0.0;
  var switchValue = false;

  void setSwitchValue(bool value) {
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Group ${widget.groupNumber}',
          style: const TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
        ),
        const Padding(padding: EdgeInsets.only(left: 32)),
        SizedBox(
          width: 150,
          height: 50,
          child: CabinSlider(
            value: sliderValue,
            onChanged: setSliderValue,
          ),
        ),
        const Padding(padding: EdgeInsets.only(left: 12)),
        CabinSwitch(
          value: switchValue,
          onToggle: setSwitchValue,
        )
      ],
    );
  }
}
