import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codered/screens/indicator.dart';
import 'package:codered/services/database/storage.dart';
import 'package:codered/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:provider/provider.dart';

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
    if (_image != null) textRecognition();
  }

  /// Shows image selection screen only when the model is ready to be used.
  Widget readyScreen() {
    return ImagePickerClass(_pickedImage);
  }

  textRecognition() async {
    final textDetector = GoogleMlKit.vision.textDetector();
    final RecognisedText recognisedText =
        await textDetector.processImage(InputImage.fromFile(_image));

    result = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        setState(() {
          result = result + ' ' + line.text + '\n';
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
        'image_url': await uploadImage(_image),
        'user_name': Provider.of<UserService>(context, listen: false).name,
        'user_id': user.uid,
        'is_verified': false
      });
    else
      await documentReference.set({
        'vision_text': result.split('\n'),
        'image_url': await uploadImage(_image),
        'user_name': Provider.of<UserService>(context, listen: false).name,
        'user_id': user.uid,
        'is_verified': false
      });
    textDetector.close();
  }

  /// Shows different screens based on the state of the custom model.
  Widget build(BuildContext context) {
    return Scaffold(body: readyScreen());
  }
}
