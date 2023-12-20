import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp/models/to_do.dart';
import 'package:uuid/uuid.dart';

class ToDoController {
  final todosCollection = FirebaseFirestore.instance.collection('todos');
  
  Future<void> addToDo(ToDo todo) async {
    var uuid = const Uuid();
    String newUuid = uuid.v4();
    await todosCollection.doc(newUuid).set({
      'title': todo.title,
      'description': todo.description,
      'isCompleted': todo.isCompleted,
      'isDescDisplayed': todo.isDescDisplayed,
      'timeStamp': todo.timeStamp,
    });
  }

  Future<void> updateToDo(ToDo todo) async {
    await todosCollection.doc(todo.id).update({
      'title': todo.title,
      'description': todo.description,
      'isCompleted': todo.isCompleted,
      'isDescDisplayed': todo.isDescDisplayed,
      'timeStamp': todo.timeStamp,
    });
  }

  Future<void> deleteToDo(String id) async {
    await todosCollection.doc(id).delete();
  }

  Stream<QuerySnapshot> getToDo() {
    return todosCollection.snapshots();
  }
}