import 'dart:async';

import 'package:flutter/services.dart';
import 'package:photo_capture_plugin/photo_capture_session.dart';

class PhotoCapturePlugin {
  static const MethodChannel _channel =
      const MethodChannel('photo_capture_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
//  static Future<PhotoCaptureSession> get photoCaptureSession async {
//    PhotoCaptureSession.initialize();
//    return Future.value();
//  }
}
