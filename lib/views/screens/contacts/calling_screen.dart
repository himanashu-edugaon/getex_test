import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallingScreen extends StatefulWidget {
  final callId;
  final userName;
  final userPhone;
  const CallingScreen({super.key, required this.callId, required this.userName, required this.userPhone});

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  String yourAppSign = "92be7c413a766ad02c96cbcaa54f650f3d52640314162891cb4b805178c1d747";
  var user  = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltCall(
        appID: 2132544568 /*input your AppID*/,
        appSign: yourAppSign /*input your AppSign*/,
        userID: widget.callId,
        userName: widget.userName,
        callID: widget.callId,
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()

        /// support minimizing
          ..topMenuBar.isVisible = true
          ..topMenuBar.buttons = [
            ZegoCallMenuBarButtonName.minimizingButton,
            ZegoCallMenuBarButtonName.showMemberListButton,
          ]
          // ..avatarBuilder = customAvatarBuilder,
      ),
    );
  }

  // Widget? customAvatarBuilder(BuildContext context, Size size, ZegoUIKitUser? user, Map<String, dynamic> extraInfo) {
  //   // Your custom avatar building logic here
  //   String userID = user?.id ?? '';
  //   return CircleAvatar(
  //     child: Text(userID.isNotEmpty ? userID[0] : ''), // Display the first character of the user ID as the avatar
  //   );
  // }

}
