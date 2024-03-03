import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:getex_test/controllers/contact_controller.dart';

void main() {
  runApp(MaterialApp(
    home: TestScreen(),
  ));
}

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: ContactController().getAllContacts(),
          builder: (c, snap) {
            var data = snap.data ?? List<Contact>.empty();
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (c, i) {
                  return ListTile(
                    onTap: ()async{
                      var update = data[i];
                      update.id = data[i].id;
                      update.name.first = "Updated Name";
                      await ContactController().updateContact(update).then((value){
                        var name = value.displayName;
                      });
                    },
                    title: Text("phone:Name: ${data[i].displayName}"),
                  );
                });
          }),
    );
  }
}
