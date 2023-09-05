import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class SettingProvider extends ChangeNotifier {
  final ImagePicker picker = ImagePicker();
  XFile? image;
  bool isImageEmpty = true;
  String? name;
  String? bio;
  TextEditingController nameCont = TextEditingController();
  TextEditingController bioCont = TextEditingController();
  bool updateProfileData = false;

  void profileOpen() {
    updateProfileData = !updateProfileData;
    notifyListeners();
  }

  void save() {
    name = nameCont.text.toString();
    bio = bioCont.text.toString();
    notifyListeners();
  }

  void imagePick() async {
    try {
      image = await picker.pickImage(source: ImageSource.gallery);
      if (image!.path.isEmpty) {
        isImageEmpty = true;
      } else {
        isImageEmpty = false;
      }
      notifyListeners();
    } catch (e) {
      isImageEmpty = true;
      notifyListeners();
    }
  }

  void clear() {
    image = null;
    isImageEmpty = true;
    notifyListeners();
  }
}
