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
  String returnText =
      "File: ${jsonData['FileName']}\nFile Type: ${jsonData['FileType']}\nFile Size: ${jsonData['FileSize']}\n";

  String fileType;
  try {
    fileType = jsonData['MIMEType'].split('/')[1];
  } catch (e) {
    return "";
  }

  switch (fileType) {
//     case "png": {
//       returnText = """${returnText}Image Width: ${jsonData['ImageWidth']}
// Image Height: ${jsonData['ImageHeight']}
// """;
//     }
//     break;
//
//     case "jpeg": {
//       returnText = """${returnText}Image Width: ${jsonData['ImageWidth']}
// Image Height: ${jsonData['ImageHeight']}
// """;
//     }
//     break;
//
//     case "mp4": {
//   returnText = """${returnText}Video Size: ${jsonData['VideoSize']}
// Media Create Date: ${jsonData['MediaCreateDate']}
// Media Modification Date: ${jsonData['MediaModifyDate']}
// Duration: ${jsonData['Duration']}
// """;
//     }
//     break;

    default:
      {
        returnText = "";

        jsonData.forEach((key, value) {
          returnText = "$returnText\n$key: $value";
        });
      }
  }
  return returnText;
}

double clamp(double x, double min, double max) {
  if (x < min) x = min;
  if (x > max) x = max;

  return x;
}
