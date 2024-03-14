

import 'package:call_log/call_log.dart';
import 'package:url_launcher/url_launcher.dart';

class PadController {
  void launchPhone(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  void launchMessage(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'sms', path: phoneNumber);
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }
  void launchDialer(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  //
  Future<Iterable<CallLogEntry>> getCallLogs(String s) async {
    Iterable<CallLogEntry> entries = await CallLog.get();
    for (var items in entries) {
      print(items.name);
      break;
    }
    return entries;
  }

}