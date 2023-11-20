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

  Future<List<String>> uploadListImageToStorage(
      String folderName, List<Uint8List> files) async {
    List<String> imageUrls = [];
    try {
      for (int i = 0; i < files.length; i++) {
        Uint8List file = files[i];
        String childName = '$folderName/image_$i.jpg';
        Reference ref = _storage.ref().child(childName);

        UploadTask uploadTask = ref.putData(file);
        TaskSnapshot snapshot = await uploadTask;
        String imageUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }

      return imageUrls;
    } catch (e) {
      print('Lỗi khi tải ảnh lên: $e');
      return [];
    }
  }
}
