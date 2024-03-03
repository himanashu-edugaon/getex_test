// import 'package:flutter/material.dart';
// im
//
// class UpdateData extends StatefulWidget {
//   UpdateData({Key? key, required this.callHistoryData}) : super(key: key);
//
//   final List<Map<String, String>> callHistoryData;
//
//   @override
//   State<UpdateData> createState() => _UpdateDataState();
// }
//
// class _UpdateDataState extends State<UpdateData> {
//   late TextEditingController _nameController;
//   late TextEditingController _emailController;
//   late TextEditingController _passwordController;
//
//   late List<flutter_contacts.Contact> callHistoryList;
//
//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController();
//     _emailController = TextEditingController();
//     _passwordController = TextEditingController();
//     callHistoryList = widget.callHistoryData;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Update Data"),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           TextField(
//             controller: _nameController,
//             decoration: InputDecoration(
//               labelText: "Name",
//             ),
//           ),
//           TextField(
//             controller: _emailController,
//             decoration: InputDecoration(
//               labelText: "Email",
//             ),
//           ),
//           TextField(
//             controller: _passwordController,
//             decoration: InputDecoration(
//               labelText: "Password",
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               // Perform update operation
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Update Successful")));
//             },
//             child: Text("Update"),
//           ),
//           SizedBox(height: 20),
//           Text(
//             'Call History:',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: callHistoryList.length,
//               itemBuilder: (context, index) {
//                 final callEntry = callHistoryList[index];
//                 return ListTile(
//                   title: Text(callEntry['callerName'] ?? 'Unknown Caller'),
//                   subtitle: Text(callEntry['phoneNumber'] ?? 'Unknown Number'),
//                   trailing: Text(callEntry['callDuration'] ?? 'Unknown Duration'),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
