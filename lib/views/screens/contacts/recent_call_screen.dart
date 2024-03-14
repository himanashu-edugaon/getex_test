import 'dart:math';

import 'package:call_log/call_log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RecentCallScreen extends StatefulWidget {
  const RecentCallScreen({Key? key}) : super(key: key);

  @override
  State<RecentCallScreen> createState() => _RecentCallScreenState();
}

class _RecentCallScreenState extends State<RecentCallScreen> {
  late Future<Iterable<CallLogEntry>> _callLogEntries;

  @override
  void initState() {
    super.initState();
    _callLogEntries = _getCallLogEntries();
  }

  Future<Iterable<CallLogEntry>> _getCallLogEntries() async {
    return await CallLog.get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recently Call'),
      ),
      body: FutureBuilder<Iterable<CallLogEntry>>(
        future: _callLogEntries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CupertinoActivityIndicator(radius: 12,),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            // Display the list of call log entries
            // Display the list of call log entries
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var call = snapshot.data!.elementAt(index);
                return ListTile(
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
                      call.name?.isNotEmpty ?? false
                          ? call.name![0]
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
                  title: Text(call.name ?? 'Unknown'),
                  subtitle: Text(call.number ?? 'Unknown number'),
                  trailing: TextButton(
                    onPressed: () {
                      _launchPhone(call.number ?? "");
                    },
                    child: const Column(
                      children: <Widget>[
                        Icon(Icons.call_outlined),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.0),
                        ),
                        //Text('Call'),
                      ],
                    ),
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

void _launchPhone(String phoneNumber) async {
  final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunch(uri.toString())) {
    await launch(uri.toString());
  } else {
    throw 'Could not launch $phoneNumber';
  }
}