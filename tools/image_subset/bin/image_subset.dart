import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

import 'package:image_subset/image_subset.dart';
import 'package:recase/recase.dart';

void main() async {
  final scriptUri = Platform.script;
  if (scriptUri.hasEmptyPath) {
    throw StateError('Could not determine script location. `Platform.script` is an empty URI.');
  }

  if (!scriptUri.isScheme('file')) {
    throw StateError('Could not determine script location. `Platform.script` is a not a file URI.');
  }

  final scriptFile = File.fromUri(scriptUri);
  if (!scriptFile.existsSync()) {
    throw StateError('Could not determine script location. `Platform.script` file URI does not exist.');
  }

  final scriptAbsolutePath = scriptFile.absolute.path;

  if (path.basename(scriptAbsolutePath) != 'image_subset.dart') {
    throw StateError(
      'Could not determine script location. `Platform.script` file URI does not point to `image_subset.dart` file.',
    );
  }

  final imageSubsetPath = path.canonicalize(path.join(path.dirname(scriptAbsolutePath), '..'));

  final cabinDemoPath = path.canonicalize(path.join(path.dirname(scriptAbsolutePath), '../../../'));
  final cabinDemoDir = Directory(cabinDemoPath);

  if (!cabinDemoDir.existsSync()) {
    throw StateError('Could not determine cabin_demo project location from current script location.');
  }

  final inputDir = Directory(path.join(imageSubsetPath, 'input/'));
  final imgOutputDir = cabinDemoDir;
  final widgetOutputFile = File(path.join(cabinDemoPath, 'lib/widgets/subset_images.dart'));

  final imageFiles = [
    for (final e in inputDir.listSync(recursive: true))
      if (e.statSync().type == FileSystemEntityType.file) File(e.path),
  ];

  print('subsetting images...');

  final handle = widgetOutputFile.openWrite(mode: FileMode.write);

  handle.write('''
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
''');

  var isFirst = true;

  for (final file in imageFiles) {
    print('subsetting image ${path.basename(file.path)}...');

    // load the image
    final image = (await img.decodeImageFile(file.path))!;

    // calculate the bounding box of the visible pixels
    final subset = await boundingBox(image: image);

    // crop the image at the bounding box
    final cropped = img.copyCrop(
      image,
      x: subset.boundingBox.left.round(),
      y: subset.boundingBox.top.round(),
      width: subset.boundingBox.width.round(),
      height: subset.boundingBox.height.round(),
    );

    // save the image to output/<filename>.png
    final outputPath = path.join(
      imgOutputDir.path,
      path.relative(file.path, from: inputDir.path),
    );
    img.encodePngFile(outputPath, cropped);

    // create a SubsetImageData instance
    final imgDataName = ReCase(path.basenameWithoutExtension(file.path)).pascalCase;

    final horizontalCrop = cropped.width.round() != image.width;
    final verticalCrop = cropped.height.round() != image.height;

    // only add an empty line between the SubsetImageDatas if we're not the first datum
    if (!isFirst) {
      handle.writeln('');
    } else {
      isFirst = false;
    }

    handle.write('''
  static const ${ReCase(imgDataName).camelCase} = SubsetImageData(
    asset: '${path.relative(file.path, from: inputDir.path)}',
    original: Rect.fromLTRB(0.0, 0.0, ${image.width}, ${image.height}),
    cropped: Rect.fromLTRB(${subset.boundingBox.left}, ${subset.boundingBox.top}, ${subset.boundingBox.right}, ${subset.boundingBox.bottom}),
    align: Alignment(
      ${horizontalCrop ? '2 * ${subset.boundingBox.left} / (${image.width} - ${subset.boundingBox.width}) - 1' : '0.0'},
      ${verticalCrop ? '2 * ${subset.boundingBox.top} / (${image.height} - ${subset.boundingBox.height}) - 1' : '0.0'},
    ),
    widthFactor: ${subset.boundingBox.width} / ${image.width},
    heightFactor: ${subset.boundingBox.height} / ${image.height},
  );
''');
  }

  handle.writeln('}');

  // finishg writing the widgets
  await handle.close();

  print('all done.');
}
