import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

import '../shared_widgets/image_picker_class.dart';

class TextRecognition extends StatefulWidget {
  @override
  _TextRecognitionState createState() => _TextRecognitionState();
}

class _TextRecognitionState extends State<TextRecognition> {
  File _image;
  var result = "";

  void _pickedImage(File image) {
    _image = image;
  }

  /// Shows image selection screen only when the model is ready to be used.
  Widget readyScreen() {
    return Column(
      children: [
        ImagePickerClass(_pickedImage),
        SizedBox(
          height: 10,
        ),
        RaisedButton(
          onPressed: textRecognition,
          child: Text('Text Recognition'),
        ),
        SizedBox(
          height: 10,
        ),
        // Column(
        //   children: _labels != null
        //       ? _labels.map((label) {
        //           return Text("${label["label"]}");
        //         }).toList()
        //       : [],
        // ),
      ],
    );
  }

  textRecognition() async {
    FirebaseVisionImage myImage = FirebaseVisionImage.fromFile(_image);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(myImage);
    result = "";
    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        setState(() {
          result = result + ' ' + line.text + '\n';
        });
      }
    }
    print("RESULT: $result");
    recognizeText.close();
  }

  /// Shows different screens based on the state of the custom model.
  Widget build(BuildContext context) {
    return Scaffold(body: readyScreen());
  }
}
