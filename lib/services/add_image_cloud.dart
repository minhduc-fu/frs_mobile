import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;

class AddImageCloud {
  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    try {
      Reference ref = _storage.ref().child(childName);
      UploadTask uploadTask = ref.putData(file);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Lỗi khi tải ảnh lên: $e');
      return '';
    }
  }
}
