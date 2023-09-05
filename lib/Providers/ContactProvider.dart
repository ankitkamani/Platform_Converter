import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../Model/AddContect_Model.dart';

class ContactProvider extends ChangeNotifier {
  List<ContactModel> contacts = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController chatController = TextEditingController();
  String img = '';
  String date = '';
  String time = '';

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }

  final ImagePicker picker = ImagePicker();
  XFile? image;
  bool isImageEmpty = true;

  void remove(int index){
    contacts.removeAt(index);
    notifyListeners();
  }

  void addContact() {
    if (nameController.text.isNotEmpty) {
      contacts.add(ContactModel(
          name: nameController.text.toString(),
          phoneNumber: phoneController.text.toString(),
          chatConversation: chatController.text.toString(),
          date: date,
          time: time,
          image: image?.path ?? ''));
      nameController.clear();
      phoneController.clear();
      chatController.clear();
      date = '';
      time = '';
      img = '';
      notifyListeners();
    }
  }

  void imagePick() async {
    try {
      image = await picker.pickImage(source: ImageSource.camera);
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
