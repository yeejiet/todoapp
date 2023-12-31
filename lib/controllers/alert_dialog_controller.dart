import 'package:flutter/material.dart';
import 'package:todoapp/models/enums/CRUD.dart';

class AlertDialogController {
  Future<dynamic> displayAlertDialog(BuildContext context, CRUD crud, String content) {
    return showDialog (
      context: context,
      builder: (BuildContext context) {
        return AlertDialog (
          title: Text (crud == CRUD.C ? "Fail to add" : "Fail to update"),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    return Colors.grey.withOpacity(0.1);
                  },
                ),
              ),
              // ignore: prefer_const_constructors
              child: Text(
                "OK",
                style: const TextStyle(color: Colors.blueGrey),
              ),
            )
          ]
        );
      }
    );
  }
}