import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/controllers/alert_dialog_controller.dart';
import 'package:todoapp/controllers/to_do_controller.dart';
import 'package:todoapp/models/enums/CRUD.dart';
import 'package:todoapp/models/to_do.dart';
import 'package:todoapp/views/manage_to_do_page.dart';

class ToDoListView extends StatelessWidget {
  const ToDoListView ({
    super.key,
    required this.toDoController,
    required this.alertDialogController,
    required this.tTextController,
    required this.dTextController,
    required this.pageController,
  });

  final ToDoController toDoController;
  final AlertDialogController alertDialogController;
  final TextEditingController tTextController;
  final TextEditingController dTextController;
  final PageController pageController;

  @override 
  Widget build(BuildContext context) {
    bool isSwitching = false;
    return StreamBuilder(
      stream: toDoController.getToDo(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState ==  ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          var todos = snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return ToDo(
             id: doc.id,
             title: data['title'],
             description: data['description'],
             isCompleted: data['isCompleted'],
             isDescDisplayed: data['isDescDisplayed'],
             timeStamp: data['timeStamp'], 
            );
          }).toList();

          todos.sort((a, b) => (b.timeStamp).compareTo(a.timeStamp));

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              var todo = todos[index];
              Key titleKey = Key(todo.id);

              return Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3)
                      )
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        key: titleKey,
                        title: Text(todo.title),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                tTextController.text = todo.title;
                                dTextController.text = todo.description;
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                      appBar: AppBar(
                                        title: const Text("Flutter To Do App"),
                                        leading: IconButton(
                                          onPressed: () {
                                            dTextController.text = "";
                                            tTextController.text = "";
                                            Navigator.pop(context);
                                          }, 
                                          icon: const Icon(Icons.arrow_back),
                                        ),
                                      ),
                                      body: ManageToDoPage(
                                        tTextController: tTextController,
                                        dTextController: dTextController,
                                        toDoController: toDoController,
                                        alertDialogController: alertDialogController,
                                        pageController: pageController,
                                        crud: CRUD.U,
                                        toDo: todo,
                                      ),
                                    )
                                  )
                                );
                              }, 
                              icon: const Icon(Icons.edit),
                              color: Colors.grey,
                            ),
                            IconButton(
                              onPressed: () {
                                toDoController.deleteToDo(todo.id);
                              }, 
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                            ),
                            Checkbox(
                              fillColor: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Colors.blueGrey;  // Color when the checkbox is selected (checked)
                                  }
                                  return null;  // Color when the checkbox is not selected (unchecked)
                                },
                              ),
                              key: ValueKey(todo.id),
                              value: todo.isCompleted,
                              onChanged: (value) {
                                todo.isCompleted = value!;
                                toDoController.updateToDo(todo);
                              },
                            )

                          ],
                        ),
                        onTap: (){
                          if(!isSwitching) {
                            isSwitching = true;
                            todo.isDescDisplayed = !todo.isDescDisplayed;
                            toDoController.updateToDo(todo);

                            // Add a delay before allowing another switch
                            Future.delayed(const Duration(milliseconds: 500),
                              () {
                                isSwitching = false;
                              }
                            );
                          }
                        },
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: todo.isDescDisplayed ? Padding(
                          key: ValueKey<bool>(todo.isDescDisplayed),
                          padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 5.0),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: 98,
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                                    child: Text(
                                      todo.description,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                )
                              ],
                            ),
                          )
                        )
                        : Container(),
                      )
                    ],
                  ),
                )
              );
            }
          );
        }
      },
    );
  }
}