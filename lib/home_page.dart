import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:to_do/add_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController taskAddController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error detected : ${snapshot.error}'),
              );
            }
            final tasks = snapshot.data!.docs;
            if (tasks.isEmpty) {
              return Center(
                child: Text('No tasks found'),
              );
            }
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.purple, Colors.deepPurple],
                    begin: Alignment.topRight,
                    end: Alignment.bottomRight),
              ),
              child: SafeArea(
                  child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  children: [
                    Text(
                      "Today's Tasks",
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontSize: 30),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          var task = tasks[index];

                          return Dismissible(
                            key: Key(task.id),
                            background: Container(
                              alignment: Alignment.centerLeft,
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                    Colors.black,
                                    Color.fromARGB(255, 251, 134, 126)
                                  ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight)),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Iconsax.task_square5,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      'Delete the task',
                                      style: GoogleFonts.poppins(
                                          color: Colors.white),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 40,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            onDismissed: (direction) async {
                              FirebaseFirestore.instance
                                  .collection('tasks')
                                  .doc(task.id)
                                  .delete();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Deleted',
                                        style: GoogleFonts.poppins(
                                            color: Colors.purple,
                                            fontSize: 15)),
                                    content: Text('Task deleted successfully',
                                        style: GoogleFonts.poppins(
                                            color: Colors.black, fontSize: 15)),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Ok',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.purple,
                                                  fontSize: 20)))
                                    ],
                                  );
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                child: ListTile(
                                  onTap: () async {
                                    FirebaseFirestore.instance
                                        .collection('tasks')
                                        .doc(task.id)
                                        .update({'status': true});
                                  },
                                  onLongPress: () async {
                                    FirebaseFirestore.instance
                                        .collection('tasks')
                                        .doc(task.id)
                                        .update({'status': false});
                                  },
                                  leading: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: const BoxDecoration(
                                          color: Colors.purple,
                                          shape: BoxShape.rectangle),
                                      child: task['status'] == true
                                          ? Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            )
                                          : Container()),
                                  title: Text(
                                    task['task'],
                                    style: GoogleFonts.poppins(fontSize: 20),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(task['desc']),
                                          Text(task['date']),
                                          Text(task['priority']),
                                          Text(task['mode'])
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              )),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddTodo(),
          );
        },
        child: const Icon(
          Iconsax.add5,
          size: 40,
          color: Colors.purple,
        ),
      ),
    );
  }
}
