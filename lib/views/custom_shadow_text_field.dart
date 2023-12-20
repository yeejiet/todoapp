import 'package:flutter/material.dart';

class CustomsShadowTextField extends StatelessWidget {
  const CustomsShadowTextField ({
    super.key,
    required this.textController,
    required this.title,
    required this.hintText,
    required this.maxLines,
  });

  final TextEditingController textController;
  final String title;
  final String hintText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column (
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          )
        ),
        const SizedBox(height: 8.0),
        Container(
          decoration:  BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2)
              )
            ]
          ),
          child: TextField(
            controller: textController,
            maxLines: maxLines,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10.0),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
}