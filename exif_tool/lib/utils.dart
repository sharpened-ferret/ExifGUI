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

  final String FILE_TYPE = jsonData['MIMEType'].split('/')[1];

  switch (FILE_TYPE) {
    case "png": {
      returnText = """${returnText}Image Width: ${jsonData['ImageWidth']}
Image Height: ${jsonData['ImageHeight']}
""";
    }
    break;

    case "jpeg": {
      debugPrint("jpeg detected");
      returnText = """${returnText}Image Width: ${jsonData['ImageWidth']}
Image Height: ${jsonData['ImageHeight']}
""";
    }
    break;

    default: {
      returnText = "Unknown File Type Detected!\nUsing Default Handling\n";

      jsonData.forEach((key, value) {
        returnText = "${returnText}\n$key: $value";
      });
    }
  }
  return returnText;
}