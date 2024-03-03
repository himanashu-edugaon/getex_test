// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:flutter/material.dart';
// import 'package:getex_test/views/screens/r_crud/insert_data.dart';
// import 'package:getex_test/views/screens/r_crud/update_data.dart';
// import 'package:getex_test/views/utils/app_extensions/app_extension.dart';
//
//
// class FetchData extends StatefulWidget {
//   const FetchData({super.key ,});
//
//   @override
//   State<FetchData> createState() => _FetchDataState();
// }
//
// class _FetchDataState extends State<FetchData> {
//   Query dbRef = FirebaseDatabase.instance.ref().child("Stud");
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(onPressed: (){
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InsertData(),));
//       },backgroundColor: Colors.orange,child: Icon(Icons.add,color: Colors.white,)),
//       appBar: AppBar(
//         title: Text("This is Fatch AppBar"),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//             child: FirebaseAnimatedList(
//               query: dbRef,
//               defaultChild: Text('Loading....'),
//               itemBuilder: (context, snapshot, animation, index) {
//                 return Container(
//                       child: Padding(
//                         padding: const EdgeInsets.only(top: 10),
//                         child: Card(
//                           shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                           color: Colors.blue,
//                           elevation: 3,
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: [
//                              10.height,
//                              Text("Name:- ${snapshot.child("name").value.toString()}"),
//                              Text("Email:- ${snapshot.child("email").value.toString()}"),
//                              Text("Password:- ${snapshot.child("password").value.toString()}"),
//                              IconButton(onPressed: (){
//                                // Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateData(snapshot: snapshot, index: index, callHistoryData: [],),));
//                              }, icon: Icon(Icons.edit)),
//                              IconButton(onPressed: (){}, icon: Icon(Icons.delete,color: Colors.red,)),
//                            ],
//                          ),
//                         ),
//                       ),
//                     );
//               },),
//           ),
//         ],
//       )
//     );
//   }
// }
