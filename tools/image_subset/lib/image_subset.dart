import 'package:image/image.dart' as img;
import 'package:tuple/tuple.dart';
import 'geometry.dart';

enum Classification { inside, outside }

typedef Classifier = Classification Function(img.Pixel);

Classification isVisible(img.Pixel color) {
  return color.a.toDouble() == 0.0 ? Classification.outside : Classification.inside;
}

class ImageSubset {
  ImageSubset(this.image, this.boundingBox);

  final img.Image image;
  final Rect boundingBox;
}

Future<Iterable<Tuple3<int, int, Classification>>> classify(
  img.Image image, {
  required Classifier classifier,
}) async {
  return image.map((p) {
    final classification = classifier(p);
    return Tuple3(p.x, p.y, classification);
  });
}

Future<ImageSubset> boundingBox({
  required img.Image image,
  Classifier classifier = isVisible,
}) async {
  late Rect rect;
  var first = true;
  const oneByOnePixel = Size(1, 1);

  for (final pixel in await classify(image, classifier: classifier)) {
    final offset = Offset(pixel.item1.toDouble(), pixel.item2.toDouble());

    if (pixel.item3 == Classification.inside) {
      if (first) {
        rect = offset & oneByOnePixel;
        first = false;
      } else {
        rect = rect.expandToInclude(offset & oneByOnePixel);
      }
    }
  }

  return ImageSubset(image, rect);
}
