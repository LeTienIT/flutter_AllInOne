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
    bool granted = false;

    if (Platform.isAndroid) {
      if (await Permission.photos.request().isGranted) {
        granted = true;
      } else if (await Permission.mediaLibrary.request().isGranted) {
        granted = true;
      } else if (await Permission.storage.request().isGranted) {
        granted = true;
      }
    } else if (Platform.isIOS) {
      if (await Permission.photos.request().isGranted) {
        granted = true;
      }
    }

    if (granted) {
      final result = await ImageGallerySaverPlus.saveImage(
        imageBytes,
        quality: 100,
        name: "edited_image_${DateTime.now().millisecondsSinceEpoch}",
      );

      return result['isSuccess'] ? 1 : 0;
    } else {
      return -1;
    }
  }

}
