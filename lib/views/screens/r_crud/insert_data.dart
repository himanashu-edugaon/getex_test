// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:getex_test/views/screens/r_crud/fatch_data.dart';
//
// class InsertData extends StatefulWidget {
//   const InsertData({super.key});
//
//   @override
//   State<InsertData> createState() => _InsertDataState();
// }
//
// class _InsertDataState extends State<InsertData> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   late DatabaseReference dbRef;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     dbRef = FirebaseDatabase.instance.ref().child("Stud");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("This is Insert AppBar"),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           TextFormField(
//             controller: nameController,
//             validator: (value) {
//               if(value != null){
//                 return "Please enter your name";
//               }
//               return null;
//             },
//             decoration: InputDecoration(
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//                 hintText: "Enter Your Name"
//             ),
//           ),
//           TextFormField(
//             controller: emailController,
//             validator: (value) {
//               if(value != null){
//                 return "Please enter your email";
//               }
//             },
//             decoration: InputDecoration(
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//                 hintText: "Enter Your Email"
//             ),
//           ),
//           TextFormField(
//             controller: passwordController,
//             validator: (value) {
//               if(value != null){
//                 return "Please enter your Password";
//               }
//             },
//             decoration: InputDecoration(
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//                 hintText: "Enter Your Password"
//             ),
//           ),
//
//           ElevatedButton(onPressed: (){
//             Map<String,dynamic> stud = {
//               "name" :  nameController.text,
//               "email" : emailController.text,
//               "password" : passwordController.text
//             };
//             dbRef.push().set(stud);
//             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Insert SuccessFul")));
//             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => FetchData(),));
//           }, child: Text("Submit")),
//         ],
//       ),
//     );
//   }
// }
