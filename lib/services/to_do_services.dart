import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do/model/to_do_model.dart';

class ToDoServices {
  CollectionReference taskCollection =
      FirebaseFirestore.instance.collection('tasks');
  Stream<List<ToDoModel>> ListTasks() {
    return taskCollection
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(taskFromFirestore);
  }

  Future createTask(String title) async {
    return await taskCollection.add({
      'title': title,
      'isCompleted': false,
      'timestamp': FieldValue.serverTimestamp()
    });
  }

  Future updateTask(uid, bool newCompleteTask) async {
    await taskCollection.doc(uid).update({'isCompleted': newCompleteTask});
  }

  Future deleteTask(uid) async {
    await taskCollection.doc(uid).delete();
  }

  List<ToDoModel> taskFromFirestore(QuerySnapshot snapshots) {
    return snapshots.docs.map((e) {
      Map<String, dynamic>? data = e.data() as Map<String, dynamic>?;
      return ToDoModel(
          uid: e.id,
          title: data?['title'] ?? '',
          isCompleted: data?['isCompleted'] ?? true);
    }).toList();
  }
}
