import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;

class AddImageCloud {
  Future<String> uploadImageToStorage(
      String folderName, Uint8List file, int accountID) async {
    try {
      String childName = '$folderName/avatarAccount$accountID';
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
      String folderName, List<Uint8List> files, int orderRentID) async {
    List<String> imageUrls = [];
    try {
      for (int i = 0; i < files.length; i++) {
        Uint8List file = files[i];
        String childName =
            '$folderName/imagesByOrderRentID$orderRentID/image_$i.jpg';
        // String childName = '$folderName/image_$i.jpg';
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

  Future<List<String>> uploadListImageFeedbackToStorage(String folderName,
      List<Uint8List> files, int orderRentID, int feedbackID) async {
    List<String> imageUrls = [];
    try {
      for (int i = 0; i < files.length; i++) {
        Uint8List file = files[i];
        String childName =
            '$folderName/imagesByOrderRentID$orderRentID/feedbackID$feedbackID/image_$i.jpg';
        // String childName = '$folderName/image_$i.jpg';
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
