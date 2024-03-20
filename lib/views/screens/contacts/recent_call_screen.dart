import 'dart:math';

import 'package:call_log/call_log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:getex_test/controllers/calling_pad_controller/calling_pad_controller.dart';
import 'package:getex_test/views/screens/contacts/update_contacts_screen.dart';
import 'package:getex_test/views/screens/history/history_screens.dart';

import 'calling_screen.dart';

class RecentCallScreen extends StatefulWidget {
  const RecentCallScreen({Key? key}) : super(key: key);

  @override
  State<RecentCallScreen> createState() => _RecentCallScreenState();
}

class _RecentCallScreenState extends State<RecentCallScreen> {
  late Future<List<CallLogEntry>> _callLogEntries;
  late Map<int, bool> _expandedStateMap;

  late PadController padsController = PadController();

  @override
  void initState() {
    super.initState();
    _callLogEntries = _getCallLogEntries();
    _expandedStateMap = {}; // Initialize the expanded state map
  }

  Future<List<CallLogEntry>> _getCallLogEntries() async {
    final callLogs = await CallLog.get();
    return callLogs.toList();
  }

  Future<List<Contact>> _getContacts() async {
    final Iterable<Contact> contacts = await FlutterContacts.getContacts();
    return contacts.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Calls'),
      ),
      body: FutureBuilder<List<CallLogEntry>>(
        future: _callLogEntries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(
                radius: 12,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            return
              ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final entry = snapshot.data![index];
                  final isExpanded = _expandedStateMap.containsKey(index)
                      ? _expandedStateMap[index]
                      : false;
                  return GestureDetector(
                    onTap:  () {
                      setState(() {
                        _expandedStateMap[index] = !(isExpanded ?? false);
                      });
                    },
                    child: Column(
                      children: [
                        ListTile(
                            title: Text(entry.name ?? 'Unknown'),
                            subtitle: Text(entry.number ?? 'Unknown number'),
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
                                entry.name?.isNotEmpty ?? false
                                    ? entry.name![0]
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
                            trailing: null
                          //onTap: () {
                          //   setState(() {
                          //     _expandedStateMap[index] = !(isExpanded ?? false);
                          //   });
                          // },

                        ),
                        if (isExpanded ?? false)
                          ButtonBar(
                              alignment: MainAxisAlignment.spaceBetween ,
                              buttonHeight: 62.0,
                              buttonMinWidth: 50.0,
                              children: <Widget>[
                                TextButton(
                                  onPressed: () {
                                   // padsController.launchPhone(entry.number ?? "");
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => CallingScreen(
                                      callId: entry.phoneAccountId,
                                      userName : entry.name,
                                      userPhone : entry.number
                                    ),));
                                  },
                                  child: const Column(
                                    children: <Widget>[
                                      Icon(Icons.call_outlined),
                                      Padding(  
                                          padding:
                                          EdgeInsets.symmetric(vertical: 1.0)),
                                      Text("Call"),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    padsController
                                        .launchMessage(entry.number ?? "");
                                  },
                                  child: const Column(
                                    children: <Widget>[
                                      Icon(Icons.message_outlined),
                                      Padding(
                                          padding:
                                          EdgeInsets.symmetric(vertical: 1.0)),
                                      Text("Message"),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    String phoneNumber = entry.number ?? "";
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HistoryScreen(
                                              phoneNumber: phoneNumber,
                                              userName: entry.name ?? ""),
                                        ));
                                  },
                                  child: const Column(
                                    children: <Widget>[
                                      Icon(Icons.history),
                                      Padding(
                                          padding:
                                          EdgeInsets.symmetric(vertical: 1.0)),
                                      Text("History"),
                                    ],
                                  ),
                                ),
                                // TextButton(
                                //   onPressed: () async {
                                //     String phoneNumber = entry.number ?? "";
                                //     final contacts = await _getContacts();
                                //     int indexOfContact = contacts.indexWhere((contact) =>
                                //         contact.phones.any((phone) => phone.number == phoneNumber)
                                //     );
                                //     if(indexOfContact != -1) {
                                //       Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //           builder: (context) => UpdatedContactScreen(
                                //             contacts: [contacts[indexOfContact]], // Pass the found contact as a list
                                //             index: indexOfContact,
                                //             id: contacts[indexOfContact].id, // Use the ID of the found contact
                                //             userImage: contacts[indexOfContact].photo, // Use the photo of the found contact
                                //           ),
                                //         ),
                                //       );
                                //     } else {
                                //       ScaffoldMessenger.of(context).showSnackBar(
                                //         SnackBar(content: Text('Contact not found')),
                                //       );
                                //     }
                                //   },
                                //   child: const Column(
                                //     children: <Widget>[
                                //       Icon(Icons.update),
                                //       Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
                                //       Text("Update"),
                                //     ],
                                //   ),
                                // ),
                              ]),
                      ],
                    ),
                  );
                },
              );
          } else {
            return const Center(
              child: Text('No call history available.'),
            );
          }
        },
      ),
    );
  }
}
