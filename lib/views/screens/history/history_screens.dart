import 'dart:math';
import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class HistoryScreen extends StatefulWidget {
  final String phoneNumber; // Phone number for which history is to be displayed
  final String userName;
  const HistoryScreen({Key? key, required this.phoneNumber,  required this.userName}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<Iterable<CallLogEntry>> _callLogEntries;
  var data;

  String? _formatDuration(Duration? duration) {
    if (duration == null) return null;

    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    String hoursStr = hours > 0 ? '$hours:' : '';
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return '$hoursStr$minutesStr:$secondsStr';
  }


  @override
  void initState() {
    super.initState();
    _callLogEntries = _getCallLogEntries();
  }

  Future<Iterable<CallLogEntry>> _getCallLogEntries() async {
    // Filter call log entries based on the specified phone number
    final Iterable<CallLogEntry> allEntries = await CallLog.get();
    return allEntries.where((entry) => entry.number == widget.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Call History for ${widget.userName}'),
      ),
      body: FutureBuilder<Iterable<CallLogEntry>>(
        future: _callLogEntries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            // Display the list of call log entries for the specified phone number
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var call = snapshot.data!.elementAt(index);
                IconData iconData = call.callType == CallType.incoming ? Icons.call_received : Icons.call_made;
                String callTextType = call.callType == CallType.incoming ? "Incoming" : "Outgoing";
                DateTime callDate = DateTime.fromMillisecondsSinceEpoch(call.timestamp ?? 0);
                String formattedDate = '${callDate.year}-${callDate.month}-${callDate.day}';
                return ListTile(
                  leading: Icon(iconData),
                  title:  Text('$callTextType',style: TextStyle(fontSize: 17),),
                  //title: Text(call.name ?? 'Unknown'),
                  subtitle:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    //  Text(call.number ?? 'Unknown duration'),
                      //Text('Date: $callTextType'),
                      Text(' $formattedDate'),
                    ],
                  ),
                  trailing: Text(_formatDuration(Duration(seconds: call.duration ?? 0)) ?? 'Unknown duration'),
                );
              },
            );
          } else {
            return Center(
              child: Text('No call history available for ${widget.phoneNumber}.'),
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
