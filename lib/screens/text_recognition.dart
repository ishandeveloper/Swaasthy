import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codered/screens/indicator.dart';
import 'package:codered/services/database/storage.dart';
import 'package:codered/services/user_services.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shared_widgets/image_picker_class.dart';

class TextRecognition extends StatefulWidget {
  @override
  _TextRecognitionState createState() => _TextRecognitionState();
}

class _TextRecognitionState extends State<TextRecognition> {
  File? _image;
  var result = "";

  void _pickedImage(File? image) {
    _image = image;
    if (_image != null) textRecognition();
  }

  /// Shows image selection screen only when the model is ready to be used.
  Widget readyScreen() {
    return ImagePickerClass(_pickedImage);
  }

  textRecognition() async {
    FirebaseVisionImage myImage = FirebaseVisionImage.fromFile(_image!);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(myImage);
    result = "";
    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        setState(() {
          result = result + ' ' + line.text! + '\n';
        });
      }
    }
    print("RESULT: $result");
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('verification_requests')
        .doc(user.uid);
    DocumentSnapshot documentSnapshot = await documentReference.get();
    if (documentSnapshot.exists)
      await documentReference.update({
        'vision_text': result.split('\n'),
        'image_url': await uploadImage(_image!),
        'user_name': Provider.of<UserService>(context, listen: false).name,
        'user_id': user.uid,
        'is_verified': false
      });
    else
      await documentReference.set({
        'vision_text': result.split('\n'),
        'image_url': await uploadImage(_image!),
        'user_name': Provider.of<UserService>(context, listen: false).name,
        'user_id': user.uid,
        'is_verified': false
      });
    recognizeText.close();
  }

  /// Shows different screens based on the state of the custom model.
  Widget build(BuildContext context) {
    return Scaffold(body: readyScreen());
  }
}
