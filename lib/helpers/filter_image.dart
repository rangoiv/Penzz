// Used for photo filters:
// https://pub.dev/packages/photofilters
// Image to PDF:
// https://camposha.info/flutter/flutter-image-to-pdf/#gsc.tab=0


import 'dart:io';

import 'package:image/image.dart' as imageLib;
import 'package:photofilters/filters/image_filters.dart';
import 'package:photofilters/filters/subfilters.dart';
//import 'package:photofilters/utils/convolution_kernels.dart';

import 'documents_database.dart';
//import 'package:penzz/constants.dart';


Future<File> editImage(File imageFile) async {
  // Decode the image from file
  var photo = imageLib.decodeImage(await imageFile.readAsBytes())!;

  // Apply filters
  var customImageFilter = ImageFilter(name: "Custom Image Filter");

  customImageFilter.addSubFilter(ContrastSubFilter(0.3));
  customImageFilter.addSubFilter(SaturationSubFilter(-0.7));

  //var gaussianKernel = ConvolutionKernel([1,2,1,2,4,2,1,2,1], bias: 0);
  //customImageFilter.addSubFilter(ConvolutionSubFilter.fromKernel(gaussianKernel));
  //customImageFilter.addSubFilter(ConvolutionSubFilter.fromKernel(sharpenKernel));

  customImageFilter.apply(photo.getBytes(), photo.width, photo.height);

  // Write image to file
  var list = imageLib.writePng(photo);
  await imageFile.writeAsBytes(list);

  //saveImage(imageFile);
  return imageFile;
}
