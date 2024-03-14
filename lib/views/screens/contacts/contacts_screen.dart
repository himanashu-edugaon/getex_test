import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart' as flutter_contacts;
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as flutter_contacts;
import 'package:getex_test/controllers/calling_pad_controller/calling_pad_controller.dart';
import 'package:getex_test/controllers/contact_controller.dart';
import 'package:getex_test/views/screens/contacts/update_contacts_screen.dart';
import 'package:getex_test/views/screens/history/history_screens.dart';
import 'package:getex_test/views/screens/home/widgets/app_widgets.dart';
import 'package:permission_handler/permission_handler.dart';

import 'add_contact_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController contactSearchController = TextEditingController();
  List<flutter_contacts.Contact> contactsList = [];
  List<flutter_contacts.Contact> originalContacts = [];
  int? expandedIndex; // Track the index of the currently expanded tile
  bool isLoading = true;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  final PadController padsController = PadController();
  var appWidgets = AppWidget();

  @override
  void initState() {
    super.initState();
    getContactPermission();
  }

  void getContactPermission() async {
    if (await Permission.contacts.isGranted) {
      fetchContacts();
    } else {
      await Permission.contacts.request();
    }
  }

  void fetchContacts() async {
    setState(() {
      isLoading = true;
    });

    Iterable<Contact> allContacts = await ContactController().getAllContacts();

    originalContacts = [];
    for (var contact in allContacts) {
      if (contact.phones.isNotEmpty) {
        originalContacts.add(contact);
      }
    }

    setState(() {
      contactsList = originalContacts;
      isLoading = false;
    });
  }

  void filterContacts(String query) {
    List<flutter_contacts.Contact> searchResult =
        originalContacts.where((contact) {
      final nameMatches =
          contact.displayName.toLowerCase().contains(query.toLowerCase());
      final phoneMatches = contact.phones.any(
          (phone) => phone.number.toLowerCase().contains(query.toLowerCase()));
      return nameMatches || phoneMatches;
    }).toList();

    setState(() {
      if (query.isEmpty) {
        contactsList = originalContacts
            .where((contact) =>
                contact.displayName.isNotEmpty && contact.phones.isNotEmpty)
            .toList();
      } else {
        contactsList = searchResult;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddContactScreen(),
              ));
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SizedBox(
          height: 54,
          child: Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Center(
                child: TextFormField(
                  onChanged: filterContacts,
                  controller: contactSearchController,
                  decoration: const InputDecoration(
                    hintText: "Search name && number",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CupertinoActivityIndicator(
                radius: 12,
              ),
            )
          : FutureBuilder(
              future: ContactController().getAllContacts(),
              builder: (c, snap) {
                return ListView.builder(
                  itemCount: contactsList.length,
                  itemBuilder: (context, index) {
                    final contact = contactsList[index];
                    return GestureDetector(
                      child: ExpansionTile(
                        title: ListTile(
                          leading: Container(
                            height: 35,
                            width: 35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 7,
                                  color: Colors.white.withOpacity(0.4),
                                  offset: const Offset(-3, -3),
                                ),
                                BoxShadow(
                                  blurRadius: 7,
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(4, 5),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(6),
                              color: const Color(0xff262626),
                            ),
                            child: Text(
                              contact.displayName.isNotEmpty
                                  ? contact.displayName[0]
                                  : "DF",
                              style: TextStyle(
                                fontSize: 23,
                                color: Colors.primaries[
                                    Random().nextInt(Colors.primaries.length)],
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          title: Text(
                            contact.displayName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          horizontalTitleGap: 15,
                        ),
                        trailing: TextButton(
                          onPressed: () {
                            padsController.launchPhone(contact.phones.first.number);
                          },
                          child: const Column(
                            children: <Widget>[
                              Icon(Icons.call),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              //Text('Call'),
                            ],
                          ),
                        ),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: ButtonBar(
                              alignment: MainAxisAlignment.spaceBetween,
                              buttonHeight: 62.0,
                              buttonMinWidth: 50.0,
                              children: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    padsController.launchMessage(contact.phones.first.number);
                                  },
                                  child: const Column(
                                    children: <Widget>[
                                      Icon(Icons.message_outlined),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 1.0),
                                      ),
                                      Text('Message'),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    String phoneNumber =
                                        contact.phones.first.number;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HistoryScreen(
                                          phoneNumber: phoneNumber,
                                          userName: contact.displayName,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Column(
                                    children: <Widget>[
                                      Icon(Icons.history),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 1.0),
                                      ),
                                      Text('History'),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    padsController.getCallLogs(contact.phones.first.number);
                                    int indexOfContact =
                                        index; // Get the index of the current contact
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UpdatedContactScreen(
                                          index: indexOfContact,
                                          id: contact.id,
                                          contacts: contactsList,
                                          userImage: contact.photo,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Column(
                                    children: <Widget>[
                                      Icon(Icons.update),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 1.0),
                                      ),
                                      Text("Update"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
    );
  }
}

