import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DialerPadScreen extends StatelessWidget {
  final String phoneNumber;

  const DialerPadScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dialer Pad'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _launchDialer(phoneNumber);
          },
          child: Text('Open Dialer Pad'),
        ),
      ),
    );
  }

  void _launchDialer(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
