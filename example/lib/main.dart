import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:photo_capture_plugin/photo_capture_session.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  print(appDocPath);
  await PhotoCaptureSession.initialize();
  final photoCaptureSession = PhotoCaptureSession.instance;
  await photoCaptureSession.start();
  print(photoCaptureSession.textureId);
  runApp(new PhotoCaptureDemoApp(photoCaptureSession));
}

class PhotoCaptureDemoApp extends StatefulWidget {
  final PhotoCaptureSession photoCaptureSession;

  PhotoCaptureDemoApp(this.photoCaptureSession);

  @override
  _PhotoCaptureDemoAppState createState() =>
      new _PhotoCaptureDemoAppState(photoCaptureSession);
}

class _PhotoCaptureDemoAppState extends State<PhotoCaptureDemoApp> {
  final PhotoCaptureSession photoCaptureSession;

  _PhotoCaptureDemoAppState(this.photoCaptureSession);

  String imagePath;



  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        floatingActionButton: new FloatingActionButton(onPressed: () {
          print("capturing");
          photoCaptureSession.capture((Map event) {
            print("capture complete");
            setState(() {
              imagePath = event['photoOutputPath'];
            });
          });
        }),
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
            child: new Column(children: [
              new AspectRatio(
                aspectRatio: 1.0,
                child: new Texture(textureId: photoCaptureSession.textureId)),
              renderImagePath()
            ]),
          ),
      ),
    );
  }
  Widget renderImagePath() {
    if (imagePath == null) { return new Text(""); }
    return renderImage();
//    return new Text(imagePath);
  }

  Widget renderImage() {
    print(imagePath.substring(7));
    return Image.file(new File(imagePath.substring(7)));
  }

//  @override
//  void initState() {
//    super.initState();
////    initPlatformState();
//  }
//
//  // Platform messages are asynchronous, so we initialize in an async method.
//  Future<void> initPlatformState() async {
//    String platformVersion;
//    // Platform messages may fail, so we use a try/catch PlatformException.
//    try {
//      platformVersion = await PhotoCapturePlugin.platformVersion;
//    } on PlatformException {
//      platformVersion = 'Failed to get platform version.';
//    }
//
//    // If the widget was removed from the tree while the asynchronous platform
//    // message was in flight, we want to discard the reply rather than calling
//    // setState to update our non-existent appearance.
//    if (!mounted) return;
//
//    setState(() {
//      _platformVersion = platformVersion;
//    });
//  }

}
