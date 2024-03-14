import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as flutter_contacts;
import 'package:getex_test/controllers/contact_controller.dart';
import 'package:getex_test/views/screens/home/widgets/app_widgets.dart';
import 'package:getex_test/views/screens/home/widgets/bottom_navigation_screen.dart';
import 'package:image_picker/image_picker.dart';


class UpdatedContactScreen extends StatefulWidget {
  final List<flutter_contacts.Contact> contacts;
  final int index;
  final String id;
  final Uint8List? userImage;

  const UpdatedContactScreen({
    super.key,
    required this.contacts,
    required this.index,
    required this.id,
    required this.userImage,
  });

  @override
  _UpdatedContactScreenState createState() => _UpdatedContactScreenState();
}

class _UpdatedContactScreenState extends State<UpdatedContactScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _numberController;
  Uint8List? _images;
  var contactController = ContactController();
  var appWidgets = AppWidget();

  @override
  void initState() {
    super.initState();

    final contact = widget.contacts[widget.index];
    _firstNameController = TextEditingController(text: contact.name.first);
    _middleNameController = TextEditingController(text: contact.name.middle);
    _lastNameController = TextEditingController(text: contact.name.last);
    _numberController = TextEditingController(text: contact.phones.first.number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Contact'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
            children: [
              ElevatedButton(
                  onPressed: (){
                _updateContact();
              },style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue)
              ), child: const Text("Save",style: TextStyle(color: Colors.black),)),
              const SizedBox(width: 6,),
              IconButton(icon: const Icon(Icons.delete),color: Colors.red,
                onPressed: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text("Delete Contact?"),
                      content: const Text("This contact will be permanently deleted from your device"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel")),
                        TextButton(
                            onPressed: (){
                              _deleteContact();
                            },
                            child: const Text("Delete")),
                      ],
                    ),
                  );
                },
              ),
            ],
                    ),
          )],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: _images != null || widget.userImage != null
                      ? MemoryImage(_images ?? widget.userImage!): null,
                  child: _images == null && widget.userImage == null
                      ? const Icon(Icons.add_a_photo_outlined):null,
                ),
              ),
              const SizedBox(height: 20),
              appWidgets.buildTextFormField(_firstNameController, "Enter Your First Name"),
              appWidgets.buildTextFormField(_middleNameController, "This contact has no middle name"),
              appWidgets.buildTextFormField(_lastNameController, "Enter Your Last Name"),
              appWidgets.buildTextFormField(_numberController, "Enter Your Number"),
            ],
          ),
        ],
      ),
    );
  }


  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        final bytes = await pickedImage.readAsBytes();
        setState(() {
          _images = bytes;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick image')),
      );
    }
  }

  Future<void> _updateContact() async {
    final updateFirstName = _firstNameController.text.trim();
    final updateMiddleName = _middleNameController.text.trim();
    final updateLastName = _lastNameController.text.trim();
    final updateNumber = _numberController.text.trim();

    final updatedContact = widget.contacts[widget.index]
      ..name.first = updateFirstName
      ..name.middle = updateMiddleName
      ..name.last = updateLastName
      ..phones.first.number = updateNumber;

    if (_images != null) {
      updatedContact.photo = _images;
    }

    try {
      await contactController.updateContact(updatedContact);
      ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(content: Text('Contact updated successfully')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavigationWidget()),
      );
    } catch (e) {
      print('Error updating contact: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating contact')),
      );
    }
  }

  Future<void> _deleteContact() async {
    try {
      final contact = widget.contacts[widget.index];
      await contactController.deleteContacts([contact]);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Deleted contact ${contact.id}")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavigationWidget()),
      );
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete contact")),
      );
    }
  }
}
