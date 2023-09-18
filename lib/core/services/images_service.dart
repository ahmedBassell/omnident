import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImagesService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> captureAndSaveImage() async {
    try {
      final XFile? imageFile =
          await _picker.pickImage(source: ImageSource.gallery);

      if (imageFile == null) {
        return null; // No image was captured
      }

      final String imagePath = await _saveImageLocally(File(imageFile.path));
      return imagePath;
    } catch (e) {
      print('Error capturing or saving image: $e');
      return null;
    }
  }

  Future<String> _saveImageLocally(File imageFile) async {
    try {
      final Directory appDirectory = await getApplicationDocumentsDirectory();
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String imagePath = '${appDirectory.path}/$timestamp.jpg';

      final File localFile = await imageFile.copy(imagePath);
      return imagePath;
    } catch (e) {
      print('Error saving image locally: $e');
      rethrow;
    }
  }
}
