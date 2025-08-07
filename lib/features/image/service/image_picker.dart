import 'dart:io';
import 'dart:typed_data';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image != null ? File(image.path) : null;
  }

  Future<File?> captureImageWithCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    return image != null ? File(image.path) : null;
  }

  Future<int> saveImageToGallery(Uint8List imageBytes) async {
    if (await Permission.storage.request().isGranted || await Permission.photos.request().isGranted) {
      final result = await ImageGallerySaverPlus.saveImage(
        imageBytes,
        quality: 100,
        name: "edited_image_${DateTime.now().millisecondsSinceEpoch}",
      );

      if (result['isSuccess']) {
        return 1;
      } else {
        return 0;
      }
    } else {
      return -1;
    }
  }
}
