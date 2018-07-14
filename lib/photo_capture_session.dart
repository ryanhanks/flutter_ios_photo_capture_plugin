import 'dart:async';

import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

typedef void VoidCallback();
typedef void EventCallback(Map event);
class PhotoCaptureSession {
  final MethodChannel _methodChannel;
  final int _textureId;
  PhotoCaptureSession._(MethodChannel methodChannel, int textureId) : _methodChannel = methodChannel, _textureId = textureId;

  static PhotoCaptureSession instance;

  static Future<bool> initialize() async {
    final MethodChannel methodChannel = new MethodChannel("bestow.io/photo_capture_session");
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    final bool initializeResponse = await methodChannel.invokeMethod('initialize', {'imageDirectoryPath': appDocPath});

    final getSessionResponse = await methodChannel.invokeMethod('getSession');
    int textureId = getSessionResponse['textureId'];
    instance = new PhotoCaptureSession._(methodChannel, textureId);
    return true;
  }

  int get textureId {
    return _textureId;
  }

  Future<bool> start() async {
    final bool success = await _methodChannel.invokeMethod('startSession');
    return success;
  }
  Future<bool> capture(EventCallback onDidFinishProcessing) async {
    final Map r = await _methodChannel.invokeMethod('preparePhotoCapture');
    int photoCaptureSettingsId = r['photoCaptureSettingsId'];

    final EventChannel capturePhotoEventChannel = new EventChannel('bestow.io/capture_photo_events/$photoCaptureSettingsId');
    final stream = capturePhotoEventChannel.receiveBroadcastStream();
    StreamSubscription streamSubscription;
    streamSubscription = stream.listen((event) async {
      print(event);
      final String photoOutputPath = event['photoOutputPath'];
      print(photoOutputPath);
      print("captured!");
      onDidFinishProcessing(event);
//      await _methodChannel.invokeMethod('disposePhotoCapture', {'photoCaptureSettingsId': photoCaptureSettingsId});
    }, onError: (error, StackTrace stackTrace) async {
      streamSubscription?.cancel();
      print(error);
      await _methodChannel.invokeMethod('disposePhotoCapture', {'photoCaptureSettingsId': photoCaptureSettingsId});
    }, onDone: () async {
      print("onDone!");
      streamSubscription.cancel();
      await _methodChannel.invokeMethod('disposePhotoCapture', {'photoCaptureSettingsId': photoCaptureSettingsId});
    });
    await Future.value(true);
    print("calling capture");
    bool response = await _methodChannel.invokeMethod('capture', {'photoCaptureSettingsId': photoCaptureSettingsId});
    print(response);
    return true;
  }

  Future<bool> stopRunning() async {
    final bool response = await _methodChannel.invokeMethod('stopRunning');
    return response;
  }

}
