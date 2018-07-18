import 'package:flutter/material.dart';
import 'package:photo_capture_plugin/photo_capture_session.dart';
import 'dart:io';

class PhotoCaptureWidget extends StatefulWidget {
  final PhotoCaptureSession photoCaptureSession;

  PhotoCaptureWidget(this.photoCaptureSession);

  @override
  State<StatefulWidget> createState() {
    return new _PhotoCaptureWidgetState(photoCaptureSession);
  }
}

class _PhotoCaptureWidgetState extends State<PhotoCaptureWidget> {
  final PhotoCaptureSession photoCaptureSession;

  _PhotoCaptureWidgetState(this.photoCaptureSession);

  String imagePath;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.lens),
          onPressed: () {
            photoCaptureSession.capture((Map event) {
              print("capture complete");
              setState(() {
                imagePath = event['photoOutputPath'];
                Navigator.pop(context, imagePath);
              });
            });
          }),
      appBar: new AppBar(
        title: const Text('Plugin example app'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(10.0),
      child: new Center(
        child: new Column(children: [
          new AspectRatio(
                aspectRatio: 1.0,
                child: new Texture(textureId: photoCaptureSession.textureId)),
        ]),
      ),
    ));
  }

  Widget renderImagePath() {
    if (imagePath == null) {
      return new Text("");
    }
    return renderImage();
//    return new Text(imagePath);
  }

  Widget renderImage() {
    print(imagePath.substring(7));
    return Image.file(new File(imagePath.substring(7)));
  }
}
