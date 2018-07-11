import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

List<CameraDescription> cameras;

Future<Null> main() async {
  cameras = await availableCameras();
  runApp(MaterialApp(home: new CameraApp()));
}

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => new _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = new CameraController(cameras[0], ResolutionPreset.high);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return new Container();
    }
    return Scaffold(
      body: new AspectRatio(
          aspectRatio:
          controller.value.aspectRatio,
          child: new CameraPreview(controller)),
      floatingActionButton: new FloatingActionButton(onPressed: (){
        getTemporaryDirectory().then((dir){
          controller.takePicture(dir.path+"/test.png").then((_){
            print("Done?");
            Share.image(path: dir.path+"/test.png", text: "Woo", title: "yey?").share();
          });
        });
      }),
    );
  }
}