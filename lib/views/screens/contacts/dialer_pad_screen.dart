import 'package:flutter/material.dart';
import 'package:getex_test/controllers/calling_pad_controller/calling_pad_controller.dart';

class DialerPadScreen extends StatelessWidget {
  final String phoneNumber;

  DialerPadScreen({super.key, required this.phoneNumber});
  final PadController padsController = PadController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dialer Pad'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            padsController.launchDialer(phoneNumber);
          },
          child: const Text('Open Dialer Pad'),
        ),
      ),
    );
  }


}
