import 'dart:io';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

ImageProvider getImageFromFile(File? f) {
  if (f != null) {
    return FileImage(f);
  } else {
    return MemoryImage(kTransparentImage);
  }
}

String generateExifDisplayString(Map jsonData) {
  String returnText = "";

  jsonData.forEach((key, value) {
    returnText = "$returnText\n$key: $value";
  });
  return returnText;
}

double clamp(double x, double min, double max) {
  if (x < min) x = min;
  if (x > max) x = max;

  return x;
}
