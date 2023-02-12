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