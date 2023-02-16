import 'package:cabin_demo/widgets/subset_images.dart';
import 'package:flutter/material.dart';
import 'package:cabin_demo/widgets/widgets.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  MediaPageState createState() => MediaPageState();
}

class MediaPageState extends State<MediaPage> {
  var switchValue = false;
  var sliderValue = 0.0;

  void toggleSwitch() {
    setState(() {
      switchValue = !switchValue;
    });
  }

  void setSliderValue(double value) {
    setState(() {
      sliderValue = value;
    });
  }

  static const radioStations = [
    'Classic',
    'Jazz',
    'Nu Jazz',
    "80's",
    'Rock n roll',
    'POP',
    'Ambient',
  ];

  static Widget stackCrossFadeLayoutBuilder(Widget topChild, Key topChildKey, Widget bottomChild, Key bottomChildKey) {
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

  @override
  Widget build(BuildContext context) {
    return CabinPageScaffold(
      title: 'Media',
      index: 2,
      positioning: SwitchPositioning.tallRight,
      background: const SubsetImage(data: SubsetImages.mediaBackground),
      switchWidget: buildSwitch(),
      body: AnimatedCrossFade(
        layoutBuilder: stackCrossFadeLayoutBuilder,
        duration: const Duration(milliseconds: 300),
        crossFadeState: switchValue ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        firstChild: Padding(
          padding: const EdgeInsets.only(left: 20, right: 30),
          child: HighlightListView(
            highlightPlacement: const Alignment(0.0, 0.35),
            itemExtent: 148,
            forceItemExtent: true,
            children: [
              for (final station in radioStations)
                CabinIconOption.left(
                  icon: const SubsetImage(data: SubsetImages.radioIcon),
                  text: station,
                ),
            ],
          ),
        ),
        secondChild: Align(
          alignment: Alignment.center,
          child: CabinPageSafeArea.forBody(
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSwitch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CabinSlider(
            value: sliderValue,
            onChanged: setSliderValue,
          ),
          const Spacer(),
          Flexible(
            flex: 2,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Press for...',
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ),
                Align(
                  widthFactor: 0.8,
                  heightFactor: 1.0,
                  child: TextButton(
                    onPressed: toggleSwitch,
                    child: AnimatedCrossFade(
                      layoutBuilder: stackCrossFadeLayoutBuilder,
                      crossFadeState: switchValue ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 150),
                      firstCurve: Curves.ease,
                      secondCurve: Curves.decelerate,
                      firstChild: const SizedBox(
                        width: 100,
                        height: 100,
                        child: SubsetImage(data: SubsetImages.musicIcon),
                      ),
                      secondChild: const SizedBox(
                        width: 100,
                        height: 100,
                        child: SubsetImage(data: SubsetImages.videoIcon),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
