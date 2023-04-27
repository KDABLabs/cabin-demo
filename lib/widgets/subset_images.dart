import 'package:flutter/material.dart';

class SubsetImageData {
  const SubsetImageData({
    required this.asset,
    required this.original,
    required this.cropped,
    required this.align,
    required this.widthFactor,
    required this.heightFactor,
  });

  SubsetImageData.fromRects({
    required this.asset,
    required this.original,
    required this.cropped,
  })  : align = Alignment(
          2 * (cropped.left - original.left) / (original.width - cropped.width) - 1,
          2 * (cropped.top - original.top) / (original.height - cropped.height) - 1,
        ),
        widthFactor = cropped.width / original.width,
        heightFactor = cropped.height / original.height;

  final String asset;
  final Rect original;
  final Rect cropped;
  final Alignment align;
  final double widthFactor;
  final double heightFactor;
}

class SubsetImage extends StatelessWidget {
  const SubsetImage({
    super.key,
    required this.data,
    this.width,
    this.height,
  });

  final SubsetImageData data;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? data.original.width,
      height: height ?? data.original.height,
      child: FractionallySizedBox(
        widthFactor: data.widthFactor,
        heightFactor: data.heightFactor,
        alignment: data.align,
        child: Image.asset(data.asset),
      ),
    );
  }
}

class SubsetImages {
  static const lightmod2Icon = SubsetImageData(
    asset: 'assets/images/subset/lightmod_2_icon.png',
    original: Rect.fromLTRB(0.0, 0.0, 142, 142),
    cropped: Rect.fromLTRB(15.0, 20.0, 123.0, 127.0),
    align: Alignment(
      2 * 15.0 / (142 - 108.0) - 1,
      2 * 20.0 / (142 - 107.0) - 1,
    ),
    widthFactor: 108.0 / 142,
    heightFactor: 107.0 / 142,
  );

  static const doNotDisturbBlueIcon = SubsetImageData(
    asset: 'assets/images/subset/do_not_disturb_blue_icon.png',
    original: Rect.fromLTRB(0.0, 0.0, 217, 384),
    cropped: Rect.fromLTRB(0.0, 0.0, 217.0, 384.0),
    align: Alignment(
      0.0,
      0.0,
    ),
    widthFactor: 217.0 / 217,
    heightFactor: 384.0 / 384,
  );

  static const lightingBackground = SubsetImageData(
    asset: 'assets/images/subset/lighting_background.png',
    original: Rect.fromLTRB(0.0, 0.0, 960, 447),
    cropped: Rect.fromLTRB(35.0, 30.0, 590.0, 443.0),
    align: Alignment(
      2 * 35.0 / (960 - 555.0) - 1,
      2 * 30.0 / (447 - 413.0) - 1,
    ),
    widthFactor: 555.0 / 960,
    heightFactor: 413.0 / 447,
  );

  static const musicIcon = SubsetImageData(
    asset: 'assets/images/subset/music_icon.png',
    original: Rect.fromLTRB(0.0, 0.0, 69, 91),
    cropped: Rect.fromLTRB(0.0, 0.0, 69.0, 91.0),
    align: Alignment(
      0.0,
      0.0,
    ),
    widthFactor: 69.0 / 69,
    heightFactor: 91.0 / 91,
  );

  static const housekeepingWhiteIcon = SubsetImageData(
    asset: 'assets/images/subset/housekeeping_white_icon.png',
    original: Rect.fromLTRB(0.0, 0.0, 142, 142),
    cropped: Rect.fromLTRB(20.0, 22.0, 124.0, 127.0),
    align: Alignment(
      2 * 20.0 / (142 - 104.0) - 1,
      2 * 22.0 / (142 - 105.0) - 1,
    ),
    widthFactor: 104.0 / 142,
    heightFactor: 105.0 / 142,
  );

  static const temperatureIcon = SubsetImageData(
    asset: 'assets/images/subset/temperature_icon.png',
    original: Rect.fromLTRB(0.0, 0.0, 142, 142),
    cropped: Rect.fromLTRB(15.0, 16.0, 127.0, 128.0),
    align: Alignment(
      2 * 15.0 / (142 - 112.0) - 1,
      2 * 16.0 / (142 - 112.0) - 1,
    ),
    widthFactor: 112.0 / 142,
    heightFactor: 112.0 / 142,
  );

  static const alarmIcon = SubsetImageData(
    asset: 'assets/images/subset/alarm_icon.png',
    original: Rect.fromLTRB(0.0, 0.0, 142, 142),
    cropped: Rect.fromLTRB(31.0, 28.0, 108.0, 106.0),
    align: Alignment(
      2 * 31.0 / (142 - 77.0) - 1,
      2 * 28.0 / (142 - 78.0) - 1,
    ),
    widthFactor: 77.0 / 142,
    heightFactor: 78.0 / 142,
  );

  static const lightmod0Icon = SubsetImageData(
    asset: 'assets/images/subset/lightmod_0_icon.png',
    original: Rect.fromLTRB(0.0, 0.0, 142, 142),
    cropped: Rect.fromLTRB(15.0, 19.0, 124.0, 128.0),
    align: Alignment(
      2 * 15.0 / (142 - 109.0) - 1,
      2 * 19.0 / (142 - 109.0) - 1,
    ),
    widthFactor: 109.0 / 142,
    heightFactor: 109.0 / 142,
  );

  static const videoIcon = SubsetImageData(
    asset: 'assets/images/subset/video_icon.png',
    original: Rect.fromLTRB(0.0, 0.0, 71, 53),
    cropped: Rect.fromLTRB(0.0, 0.0, 71.0, 53.0),
    align: Alignment(
      0.0,
      0.0,
    ),
    widthFactor: 71.0 / 71,
    heightFactor: 53.0 / 53,
  );

  static const climateBackground = SubsetImageData(
    asset: 'assets/images/subset/climate_background.png',
    original: Rect.fromLTRB(0.0, 0.0, 960, 447),
    cropped: Rect.fromLTRB(371.0, 0.0, 713.0, 242.0),
    align: Alignment(
      2 * 371.0 / (960 - 342.0) - 1,
      2 * 0.0 / (447 - 242.0) - 1,
    ),
    widthFactor: 342.0 / 960,
    heightFactor: 242.0 / 447,
  );

  static const logo = SubsetImageData(
    asset: 'assets/images/subset/logo.png',
    original: Rect.fromLTRB(0.0, 0.0, 913, 661),
    cropped: Rect.fromLTRB(0.0, 0.0, 750.0, 661.0),
    align: Alignment(
      2 * 0.0 / (913 - 750.0) - 1,
      0.0,
    ),
    widthFactor: 750.0 / 913,
    heightFactor: 661.0 / 661,
  );

  static const lightmod1Icon = SubsetImageData(
    asset: 'assets/images/subset/lightmod_1_icon.png',
    original: Rect.fromLTRB(0.0, 0.0, 142, 142),
    cropped: Rect.fromLTRB(21.0, 26.0, 117.0, 121.0),
    align: Alignment(
      2 * 21.0 / (142 - 96.0) - 1,
      2 * 26.0 / (142 - 95.0) - 1,
    ),
    widthFactor: 96.0 / 142,
    heightFactor: 95.0 / 142,
  );

  static const doNotDisturbIcon = SubsetImageData(
    asset: 'assets/images/subset/do_not_disturb_icon.png',
    original: Rect.fromLTRB(0.0, 0.0, 142, 142),
    cropped: Rect.fromLTRB(35.0, 15.0, 99.0, 127.0),
    align: Alignment(
      2 * 35.0 / (142 - 64.0) - 1,
      2 * 15.0 / (142 - 112.0) - 1,
    ),
    widthFactor: 64.0 / 142,
    heightFactor: 112.0 / 142,
  );

  static const mediaBackground = SubsetImageData(
    asset: 'assets/images/subset/media_background.png',
    original: Rect.fromLTRB(0.0, 0.0, 960, 447),
    cropped: Rect.fromLTRB(255.0, 37.0, 495.0, 286.0),
    align: Alignment(
      2 * 255.0 / (960 - 240.0) - 1,
      2 * 37.0 / (447 - 249.0) - 1,
    ),
    widthFactor: 240.0 / 960,
    heightFactor: 249.0 / 447,
  );

  static const mediaIcon = SubsetImageData(
    asset: 'assets/images/subset/media_icon.png',
    original: Rect.fromLTRB(0.0, 0.0, 142, 142),
    cropped: Rect.fromLTRB(19.0, 26.0, 122.0, 121.0),
    align: Alignment(
      2 * 19.0 / (142 - 103.0) - 1,
      2 * 26.0 / (142 - 95.0) - 1,
    ),
    widthFactor: 103.0 / 142,
    heightFactor: 95.0 / 142,
  );

  static const lightingIcon = SubsetImageData(
    asset: 'assets/images/subset/lighting_icon.png',
    original: Rect.fromLTRB(0.0, 0.0, 142, 142),
    cropped: Rect.fromLTRB(25.0, 15.0, 117.0, 126.0),
    align: Alignment(
      2 * 25.0 / (142 - 92.0) - 1,
      2 * 15.0 / (142 - 111.0) - 1,
    ),
    widthFactor: 92.0 / 142,
    heightFactor: 111.0 / 142,
  );

  static const temperatureSlider = SubsetImageData(
    asset: 'assets/images/subset/temperature_slider.png',
    original: Rect.fromLTRB(0.0, 0.0, 172, 376),
    cropped: Rect.fromLTRB(0.0, 0.0, 172.0, 376.0),
    align: Alignment(
      0.0,
      0.0,
    ),
    widthFactor: 172.0 / 172,
    heightFactor: 376.0 / 376,
  );

  static const radioIcon = SubsetImageData(
    asset: 'assets/images/subset/radio_icon.png',
    original: Rect.fromLTRB(0.0, 0.0, 142, 142),
    cropped: Rect.fromLTRB(24.0, 23.0, 119.0, 107.0),
    align: Alignment(
      2 * 24.0 / (142 - 95.0) - 1,
      2 * 23.0 / (142 - 84.0) - 1,
    ),
    widthFactor: 95.0 / 142,
    heightFactor: 84.0 / 142,
  );

  static const housekeepingIcon = SubsetImageData(
    asset: 'assets/images/subset/housekeeping_icon.png',
    original: Rect.fromLTRB(0.0, 0.0, 142, 142),
    cropped: Rect.fromLTRB(28.0, 14.0, 133.0, 119.0),
    align: Alignment(
      2 * 28.0 / (142 - 105.0) - 1,
      2 * 14.0 / (142 - 105.0) - 1,
    ),
    widthFactor: 105.0 / 142,
    heightFactor: 105.0 / 142,
  );

  static const housekeepingBackground = SubsetImageData(
    asset: 'assets/images/subset/housekeeping_background.png',
    original: Rect.fromLTRB(0.0, 0.0, 960, 447),
    cropped: Rect.fromLTRB(529.0, 106.0, 713.0, 290.0),
    align: Alignment(
      2 * 529.0 / (960 - 184.0) - 1,
      2 * 106.0 / (447 - 184.0) - 1,
    ),
    widthFactor: 184.0 / 960,
    heightFactor: 184.0 / 447,
  );
}
