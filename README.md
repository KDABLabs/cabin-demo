# cabin_demo

Flutter example app developed by KDAB, adapted from a Qt example application.

## Building & Running

```shell
$ git clone https://github.com/KDAB/cabin_demo
$ cd cabin_demo
$ flutter run
```

## Updating the images

The cabin demo uses _subset_ images in all places, to lower the memory bandwidth
requirements.

### Subset Images 
Often, images / icons only have a little amount visible pixels in the middle,
and the rest is just transparent pixels.

When drawing images like these using flutter, alpha-blending those transparent
pixels at the border still takes up valuable memory bandwidth.

To combat this problem, we clip all images to their visible pixels
(== _subsetting_) and then add padding around the subset image, so it still
renders the same as the original image.

### Image Subsetting Tool

The tool that does that is in the `tools/image_subset` directory.

When run, the tool:
  - produces one image in  `assets/.../image.png` that's clipped to its visible
    pixels for each image in the `tools/image_subset/input/.../image.png`
    directory
    
  - generates a `lib/widgets/subset_images.dart` file which contains
    - a `SubsetImageData` class,
      containing info about the subset,
      so we can make the subset image render exactly the same as the original
      image
    - a `SubsetImage` widget,
      which will take a `SubsetImageData` and use it to render a subset image
      exactly the same as the original image
    - a `SubsetImages` class,
      containing the `static const SubsetImageData` for each image

The add a new image that should be subset, add it to
`tools/image_subset/input/...` and rerun the tool, like this:

```shell
$ dart run tools/image_subset/bin/image_subset.dart
```
