import 'package:image_picker/image_picker.dart';

// ImageSource là của image_picker để xác định nguồn ảnh (từ thư viện hoặc camera)
pickAImage(ImageSource source) async {
  final ImagePicker _imagePicker =
      ImagePicker(); //ImagePicker dùng để thao tác liên quan đến ảnh
  XFile? _file = await _imagePicker.pickImage(
      source: source); //XFile đại diện cho 1 tệp ảnh đã chọn
  if (_file != null) {
    return await _file
        .readAsBytes(); // đọc dữ liệu từ_file và trả về dưới dạng mảng byte(Uint8List). lưu trữ hoặc xử lý ảnh sau khi nó được chọn
  } else {
    print('No Image Selected!');
    return null;
  }
}
