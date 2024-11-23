import 'dart:typed_data';

class FileService {
  static FileService? _instance;

  static FileService getInstance() {
    _instance ??= FileService();
    return _instance!;
  }

  Future<String> searchFilepath() async {
    // This method should return the path where the file will be saved

    return '';
  }

  Future<void> saveFile(Uint8List report, String path) async {
    // This method should save the file in the path
  }
}
