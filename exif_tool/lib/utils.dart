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
  String returnText = "File: ${jsonData['FileName']}\nFile Type: ${jsonData['FileType']}\nFile Size: ${jsonData['FileSize']}\n";
  return returnText;
}