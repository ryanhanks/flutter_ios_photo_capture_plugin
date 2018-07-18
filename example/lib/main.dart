import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:photo_capture_plugin/photo_capture_session.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:photo_capture_plugin/photo_capture_widget.dart';

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

class PhotoCaptureDemoApp extends StatelessWidget {
  final PhotoCaptureSession photoCaptureSession;

  PhotoCaptureDemoApp(this.photoCaptureSession);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(home: new ManagePhotoWidget(photoCaptureSession));
  }
}

class ManagePhotoWidget extends StatefulWidget {
  final PhotoCaptureSession photoCaptureSession;

  ManagePhotoWidget(this.photoCaptureSession);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _ManagePhotoWidgetState(photoCaptureSession);
  }
}

class _ManagePhotoWidgetState extends State<ManagePhotoWidget> {
  final PhotoCaptureSession photoCaptureSession;

  _ManagePhotoWidgetState(this.photoCaptureSession);

  String imagePath;

//  @override
//  void initState() {
//    // TODO: implement initState
//
//    super.initState();
//  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Manage Photo"),
        ),
        body: renderBody(context));
  }

  Widget renderBody(BuildContext context) {
    return new Container(
        padding: new EdgeInsets.all(10.0),
        child:
            new Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          renderPhoto(),
          new Container(
            height: 10.0,
          ),
          renderPhotoEditControl(context)
        ]));
  }

  Widget renderPhoto() {
    if (imagePath == null) {
      return new Container(
          child: AspectRatio(
              aspectRatio: 1.0,
              child: new Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.grey.withAlpha(100),
                child: new FittedBox(
                  fit: BoxFit.fill,
                  child: new Icon(
                    Icons.photo,
                    color: Colors.grey,
                  ),
                ),
              )));
    } else {
      return Image.file(new File(imagePath.substring(7)));
    }
  }

  Widget renderPhotoEditControl(BuildContext context) {
    return new FlatButton(
      child: new Text("Edit"),
      onPressed: () async {
        final imageFilePath =
            await Navigator.push(context, new MaterialPageRoute(
          builder: (context) {
            return new PhotoCaptureWidget(photoCaptureSession);
          },
        ));
        setState(() {
          imagePath = imageFilePath;
        });
        print("Pressed");
      },
    );
  }
}
//class PhotoCaptureDemoApp extends StatefulWidget {
//  final PhotoCaptureSession photoCaptureSession;
//
//  PhotoCaptureDemoApp(this.photoCaptureSession);
//
//  @override
//  _PhotoCaptureDemoAppState createState() =>
//      new _PhotoCaptureDemoAppState(photoCaptureSession);
//}

//class _PhotoCaptureDemoAppState extends State<PhotoCaptureDemoApp> {
//  final PhotoCaptureSession photoCaptureSession;
//
//  _PhotoCaptureDemoAppState(this.photoCaptureSession);
//
//  String imagePath;
//
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      home: new PhotoCaptureWidget(photoCaptureSession),
//    );
//  }
//
//  Widget renderImagePath() {
//    if (imagePath == null) {
//      return new Text("");
//    }
//    return renderImage();
////    return new Text(imagePath);
//  }
//
//  Widget renderImage() {
//    print(imagePath.substring(7));
//    return Image.file(new File(imagePath.substring(7)));
//  }
//
////  @override
////  void initState() {
////    super.initState();
//////    initPlatformState();
////  }
////
////  // Platform messages are asynchronous, so we initialize in an async method.
////  Future<void> initPlatformState() async {
////    String platformVersion;
////    // Platform messages may fail, so we use a try/catch PlatformException.
////    try {
////      platformVersion = await PhotoCapturePlugin.platformVersion;
////    } on PlatformException {
////      platformVersion = 'Failed to get platform version.';
////    }
////
////    // If the widget was removed from the tree while the asynchronous platform
////    // message was in flight, we want to discard the reply rather than calling
////    // setState to update our non-existent appearance.
////    if (!mounted) return;
////
////    setState(() {
////      _platformVersion = platformVersion;
////    });
////  }
//
//}
