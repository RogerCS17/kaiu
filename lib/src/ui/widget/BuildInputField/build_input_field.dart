import 'package:flutter/material.dart';


Widget buildInputField(String label, TextEditingController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 10),
      Container(
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ),
      SizedBox(height: 20),
    ],
  );
}