import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:path/path.dart' as p;

class Squash {
  Squash._();

  static Future<String> compressImage(SquashObject object) async {
    return compute(_squashCompress, object);
  }

  static Future<dynamic> compressImageQueue(SquashObject object) async {
    final receiver = ReceivePort();
    final message = IsolateMessage(
      object,
      receiver.sendPort,
    );
    void compressFn(IsolateMessage message) {}
    await Isolate.spawn(compressFn, message);
    final sendPort = await receiver.first;
    final answer = ReceivePort();
    sendPort.send([answer.sendPort, object]);
    return answer.first;
  }

  static String _squashCompress(SquashObject object) {
    final image = decodeImage(object.imageFile.readAsBytesSync());

    print(object.imageFile.path);
    final imageExt = getImageFormatFromPath(object.imageFile.path);

    final tempPath = p.join(
      object.path,
      'img_${DateTime.now().millisecondsSinceEpoch}.$imageExt',
    );

    final tempFile = File(tempPath);

    switch (imageExt) {
      case ImageFormat.png:
        tempFile.writeAsBytesSync(encodePng(image, level: object.step));
        break;
      case ImageFormat.gif:
        tempFile.writeAsBytesSync(encodeGif(image, samplingFactor: 10));
        break;
      case ImageFormat.jpeg:
        tempFile.writeAsBytesSync(encodeJpg(image, quality: object.quality));
        break;
      default:
        throw Exception("Incompatible image format");
    }

    return tempFile.path;
  }
}

class IsolateMessage {
  final SquashObject object;
  final SendPort sendPort;
  IsolateMessage(
    this.object,
    this.sendPort,
  );
}

class SquashObject {
  final File imageFile;
  final String path;
  final int quality;
  final int step;

  SquashObject({
    @required this.imageFile,
    @required this.path,
    this.quality = 80,
    this.step = 6,
  });
}

const List<String> _jpegExt = ['.jpg', '.JPG', '.jpeg', '.JPEG'];

const List<String> _pngExt = ['.png', '.PNG'];

const List<String> _gifExt = ['.gif', '.GIF'];

enum ImageFormat {
  png,
  jpeg,
  gif,
  invalid,
}

ImageFormat getImageFormatFromPath(String path) {
  final ext = p.extension(path);
  if (_jpegExt.contains(ext)) {
    return ImageFormat.jpeg;
  } else if (_pngExt.contains(ext)) {
    return ImageFormat.png;
  } else if (_gifExt.contains(ext)) {
    return ImageFormat.gif;
  } else {
    return ImageFormat.invalid;
  }
}
