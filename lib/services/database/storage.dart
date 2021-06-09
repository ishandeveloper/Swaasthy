import 'dart:io';

import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firestorage;

import 'package:uuid/uuid.dart';

Future<dynamic> uploadImage(File imageFile, {Asset? asset}) async {
  firestorage.UploadTask _uploadTask;
  firestorage.FirebaseStorage _storage = firestorage.FirebaseStorage.instance;

  // Check If Image Can be compressed, If yes then compress the image
  // if (asset != null && canBeCompressed(asset))
  // imageFile =
  //     await compressImage(imageFile, await getCompressedImagePath(asset));

  /* Filename for the Image*/
  var uuid = Uuid();
  String path = "images/${uuid.v4()}.${imageFile.path.split('.').last}";

  _uploadTask = _storage.ref().child(path).putFile(imageFile);

  firestorage.TaskSnapshot _taskSnapshot = await _uploadTask;

  return _taskSnapshot.ref.getDownloadURL();
}
