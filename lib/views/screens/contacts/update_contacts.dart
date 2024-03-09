import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as flutter_contacts;
import 'package:getex_test/controllers/contact_controller.dart';
import 'package:getex_test/views/screens/home/Buttom_navation.dart';
import 'package:image_picker/image_picker.dart';


class UpdatedContactScreen extends StatefulWidget {
  final List<flutter_contacts.Contact> contacts;
  final int index;
  final String id;
  final Uint8List? userImage;

  const UpdatedContactScreen({
    Key? key,
    required this.contacts,
    required this.index,
    required this.id,
    required this.userImage,
  }) : super(key: key);

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

  @override
  void initState() {
    super.initState();

    final contact = widget.contacts[widget.index];
    _firstNameController = TextEditingController(text: contact.name.first ?? '');
    _middleNameController = TextEditingController(text: contact.name.middle ?? '');
    _lastNameController = TextEditingController(text: contact.name.last ?? '');
    _numberController = TextEditingController(text: contact.phones.first.number ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Contact'),
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
                      ? Icon(Icons.add_a_photo_outlined):null,
                ),
              ),
              const SizedBox(height: 20),
              buildTextFormField(_firstNameController, "Enter Your First Name"),
              buildTextFormField(_middleNameController, "This contact has no middle name"),
              buildTextFormField(_lastNameController, "Enter Your Last Name"),
              buildTextFormField(_numberController, "Enter Your Number"),
              const SizedBox(height: 30),
              buildElevatedButton("Update Contact", Colors.tealAccent, _updateContact),
              const SizedBox(height: 20),
              //buildElevatedButton("Delete Contact", Colors.deepOrange, _deleteContact),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text("Alert....!"),
                    content: Text("Sure You Wants to Delete"),
                    actions: <Widget>[
                      TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: Text("No")),
                      TextButton(
                          onPressed: (){
                            _deleteContact();
                          },
                          child: Text("Yes")),
                    ],
                  ),
                ),
                child: Text("Delete Contact",
                  style: const TextStyle(fontSize: 20, color: Colors.black87),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTextFormField(TextEditingController controller, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        controller: controller,
      ),
    );
  }

  Widget buildElevatedButton(String text, Color color, Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child:
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, color: Colors.black87),
        ),
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
        MaterialPageRoute(builder: (context) => const MyHomePage()),
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
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete contact")),
      );
    }
  }
}
