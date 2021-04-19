import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Squash {
  Squash._();

  static Future<File> compressImage(SquashObject object) async {
    return compute(_squashCompress, object);
  }

  static Future<dynamic> compressImageQueue(SquashObject object) async {
    final receiver = ReceivePort();
    final message = IsolateMessage(
      object,
      receiver.sendPort,
    );

    await Isolate.spawn(_isolateFn, message);
    final result = await receiver.first;

    return result;
  }

  static void _isolateFn(IsolateMessage message) {
    final file = _squashCompress(message.object);
    message.sendPort.send(file);
  }

  static File _squashCompress(SquashObject object) {
    final bytes = object.imageFile.readAsBytesSync();
    // Check if its animated

    final image = decodeImage(bytes);

    final imageExt = getImageFormatFromPath(object.imageFile.path);

    final tempPath = p.join(
      object.path,
      'img_${uuid.v4()}.${imageExt.name}',
    );

    final tempFile = File(tempPath);

    /// If its animation just save in temp as is
    final animated = _isAnimated(bytes);
    // Return if its animated
    if (animated) {
      tempFile.writeAsBytesSync(bytes);
      return tempFile;
    }

    switch (imageExt) {
      case ImageFormat.png:
        tempFile.writeAsBytesSync(encodePng(
          image,
          level: object.step,
        ));

        break;
      case ImageFormat.gif:
        tempFile.writeAsBytesSync(
          encodeGif(image),
        );

        break;
      case ImageFormat.jpeg:
        tempFile.writeAsBytesSync(
          encodeJpg(image, quality: object.quality),
        );
        break;
      default:
        throw Exception("Incompatible image format");
    }

    return tempFile;
  }

  static bool _isAnimated(List<int> bytes) {
    final decoder = findDecoderForData(bytes);
    final info = decoder.startDecode(bytes);
    return info.numFrames > 1;
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

extension ImageFormatExtension on ImageFormat {
  /// Name of the channel
  String get name {
    final self = this;
    return self.toString().split('.').last;
  }
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
