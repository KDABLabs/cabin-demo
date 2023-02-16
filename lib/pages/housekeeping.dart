import 'package:cabin_demo/widgets/subset_images.dart';
import 'package:flutter/material.dart';
import 'package:cabin_demo/widgets/widgets.dart';

class HousekeepingPage extends StatefulWidget {
  const HousekeepingPage({super.key});

  @override
  HousekeepingPageState createState() => HousekeepingPageState();
}

class HousekeepingPageState extends State<HousekeepingPage> {
  var switchValue = false;

  static const items = [
    {
      'icon': 'assets/images/cealw.icon.png',
      'text': 'Start Cleaning',
      'widget': SubsetImage(data: SubsetImages.housekeepingWhiteIcon)
    },
    {
      'icon': 'assets/images/disturb.icon.png',
      'text': 'Do not disturb',
      'widget': SubsetImage(data: SubsetImages.doNotDisturbIcon)
    },
    {
      'icon': 'assets/images/alarm.icon.png',
      'text': 'Set Alarm',
      'widget': SubsetImage(data: SubsetImages.alarmIcon),
    },
    {
      'icon': 'assets/images/cealw.icon.png',
      'text': 'Start Cleaning',
      'widget': SubsetImage(data: SubsetImages.housekeepingWhiteIcon)
    },
    {
      'icon': 'assets/images/disturb.icon.png',
      'text': 'Do not disturb',
      'widget': SubsetImage(data: SubsetImages.doNotDisturbIcon)
    },
    {
      'icon': 'assets/images/alarm.icon.png',
      'text': 'Set Alarm',
      'widget': SubsetImage(data: SubsetImages.alarmIcon),
    },
  ];

  void setSwitchValue(bool value) {
    setState(() {
      switchValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CabinPageScaffold(
      title: 'Housekeeping',
      index: 3,
      background: const SubsetImage(data: SubsetImages.housekeepingBackground),
      positioning: SwitchPositioning.tallLeft,
      switchWidget: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CabinSwitch(
          showOnOff: false,
          value: switchValue,
          onToggle: setSwitchValue,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: HighlightListView(
          itemExtent: 148,
          highlightPlacement: const Alignment(0.0, 0.35),
          children: [
            for (final item in items)
              CabinIconOption.right(
                icon: item['widget'] as Widget,
                text: item['text'] as String,
              ),
          ],
        ),
      ),
    );
  }
}
