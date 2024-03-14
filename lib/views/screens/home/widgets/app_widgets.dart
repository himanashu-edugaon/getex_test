
import 'package:flutter/material.dart';

class AppWidget{
  Widget buildTextFormField(TextEditingController controller, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        controller: controller,
      ),
    );
  }

  Widget buildElevatedButton(String text, Color color, Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child:
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, color: Colors.black87),
        ),
      ),
    );
  }

}