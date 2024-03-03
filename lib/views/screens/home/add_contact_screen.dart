import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:getex_test/views/screens/home/Buttom_navation.dart';
import 'package:image_picker/image_picker.dart';


class AddContactScreen extends StatefulWidget {
  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  Uint8List? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add new Contect"),
        ),
        body: ListView(
          children: [
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    SizedBox(height: 50,),
                    GestureDetector(
                      onTap: (){
                        _getImage();
                      },
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: _image != null ? MemoryImage(_image!):null,
                        child:  _image ==  null ? Icon(Icons.add_a_photo_outlined) : null,
                      ),
                    ),
                    SizedBox(height: 50,),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'
                          ,border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))

                      ),
                    ),
                    SizedBox(height: 20,),
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: 'Phone'
                          ,border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))

                      ),
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 10,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                      ),
                      onPressed: () {
                        _addContact(context);
                      },
                      child: Text('Add Contact',style: TextStyle(fontSize: 30,color: Colors.black87),),
                    ),
                  ],
                )
            ),
          ],
        )
    );
  }

  Future<void> _getImage() async{
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if(pickedImage != null){
      final bytes = await pickedImage.readAsBytes();
      setState(() {
        _image = bytes;
      });
    }
  }



  Future<void> _addContact(BuildContext context) async {
    try {
      String name = _nameController.text.trim();
      String phone = _phoneController.text.trim();
      // Uint8List? userPick =
      if (name.isNotEmpty && phone.isNotEmpty) {
        Contact newContact = Contact(
          givenName: name,
          // displayName: ,
          // middleName: ,
          avatar: _image,
          phones: [Item(label: 'mobile', value: phone)],
        );

        await ContactsService.addContact(newContact);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contact added successfully')),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(),));

        _nameController.clear();
        _phoneController.clear();
        setState(() {
          _image = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please provide a name and phone number')),
        );
      }
    } catch (e) {
      print('Error adding contact: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding contact')),
      );
    }
  }
}
