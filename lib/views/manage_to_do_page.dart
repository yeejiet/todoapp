import 'package:flutter/material.dart';
import 'package:todoapp/controllers/alert_dialog_controller.dart';
import 'package:todoapp/controllers/to_do_controller.dart';
import 'package:todoapp/models/enums/CRUD.dart';
import 'package:todoapp/models/to_do.dart';
import 'package:todoapp/views/custom_shadow_text_field.dart';

class ManageToDoPage extends StatelessWidget {
  const ManageToDoPage({
    super.key,
    required this.toDoController,
    required this.alertDialogController,
    required this.tTextController,
    required this.dTextController,
    required this.pageController,
    required this.crud,
    this.toDo,
  });

  final ToDoController toDoController;
  final AlertDialogController alertDialogController;
  final TextEditingController tTextController;
  final TextEditingController dTextController;
  final PageController pageController;
  final CRUD crud;
  final ToDo? toDo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  crud == CRUD.C ? "Add To Do" : "Update To Do",
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              CustomsShadowTextField(
                textController: tTextController,
                title: 'Title',
                hintText: 'Ex: To Do',
                maxLines: 1,
              ),
              CustomsShadowTextField(
                textController: dTextController,
                title: 'Description',
                hintText: 'Ex: Description',
                maxLines: 5,
              ),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        return Colors.grey.withOpacity(0.1);
                      },
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        return Colors.grey.shade100;
                      },
                    ),
                  ),
                  onPressed: () async {
                    if (tTextController.text == "") {
                      alertDialogController.displayAlertDialog(context, crud, 'Title cannot be empty');
                      return;
                    }
                    
                    if (dTextController.text == "") {
                      alertDialogController.displayAlertDialog(context, crud, 'Decription cannot be empty');
                      return;
                    }

                    switch (crud) {
                      case CRUD.C:
                        DateTime now = DateTime.now();
                        int millisecondsSinceEpach = now.microsecondsSinceEpoch;
                        String epachTime = millisecondsSinceEpach.toString();
                        var newToDo = ToDo(
                          id: '',
                          title: tTextController.text,
                          description: dTextController.text,
                          isCompleted: false,
                          isDescDisplayed: false,
                          timeStamp: epachTime,
                        );
                        toDoController.addToDo(newToDo);

                        FocusScope.of(context).unfocus();

                        pageController.animateToPage(
                          0, 
                          duration: const Duration(microseconds: 500),
                          curve: Curves.easeInSine
                        );
                        break;
                      case CRUD.U: 
                        toDo?.title = tTextController.text;
                        toDo?.description = dTextController.text;
                        toDoController.updateToDo(toDo!);
                        Navigator.pop(context);
                        break;
                      default:
                        break;
                    }

                    tTextController.text = "";
                    dTextController.text = "";
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        crud == CRUD.C ? Icons.add : Icons.edit, 
                        color: Colors.blueGrey,
                      ),
                      const SizedBox(width: 8),  // Adjust the spacing between the icon and the text
                      Text(
                        crud == CRUD.C ? "Add To Do" : "Update To Do",
                        style: const TextStyle(color: Colors.blueGrey),
                      ),
                    ],
                  )

                ),
              )
            ],
          ),
        ),
      )
    );
  }
}