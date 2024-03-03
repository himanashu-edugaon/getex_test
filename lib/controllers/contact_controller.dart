
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactController {
  TextEditingController searchController = TextEditingController();
  List<Contact> contacts = [];
  List<Contact> originalContacts = [];
  int? expandedIndex; // Track the index of the currently expanded tile
  bool isLoading = true;

  Future<List<Contact>> getAllContacts() async {
    return await FlutterContacts.getContacts(
        withAccounts: true,
        withProperties: true,
        withThumbnail: true,
        withPhoto: true);
  }

  Future<Contact> updateContact(Contact contact) async {
    return await FlutterContacts.updateContact(contact);
  }


  Future<void> deleteContacts(List<Contact> contactIds) async {
    try {
      // Delete contacts using the IDs
      await FlutterContacts.deleteContacts(contactIds);
      print('Contacts deleted successfully');
    } catch (e) {
      print('Failed to delete contacts: $e');
      // Rethrow the error to propagate it further if needed
      rethrow;
    }
  }




  final MethodChannel _channel = MethodChannel('contact_channel');

  Future<void> addContact(String name, String phoneNumber) async {
    try {
      await _channel.invokeMethod('addContact', {'name': name, 'phoneNumber': phoneNumber});
    } on PlatformException catch (e) {
      print("Failed to add contact: '${e.message}'.");
    }
  }



  void getPermissionUser() async {
    if (await Permission.phone.request().isGranted) {
      getAllContacts();
    } else {
      await Permission.phone.request();
    }
  }


}
