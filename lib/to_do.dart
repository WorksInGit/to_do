import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:to_do/model/to_do_model.dart';
import 'package:to_do/services/to_do_services.dart';
import 'package:to_do/to_do_dialog.dart';

class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  TextEditingController taskAddController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.jpg'), fit: BoxFit.cover)),
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: StreamBuilder<List<ToDoModel>>(
            stream: ToDoServices().ListTasks(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator(color: Colors.deepPurple,));
              }
              List<ToDoModel>? tasks = snapshot.data;

              return Column(
                children: [
                  Text(
                    "Today's Tasks",
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 30),
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
                      itemCount: tasks!.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(tasks![index].uid),
                          background: Container(
                            alignment: Alignment.centerLeft,
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [Colors.red, Colors.black],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight)),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  const Icon(Iconsax.task_square5,color: Colors.white,),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    'Delete the task',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.delete,color: Colors.white,size: 40,)
                                ],
                              ),
                            ),
                          ),
                          onDismissed: (direction) async {
                            await ToDoServices().deleteTask(tasks[index].uid);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: ListTile(
                                onTap: () {
                                  bool newCompleteTask =
                                      !tasks[index].isCompleted;
                                  ToDoServices().updateTask(
                                      tasks[index].uid, newCompleteTask);
                                },
                                leading: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: const BoxDecoration(
                                        color: Colors.purple,
                                        shape: BoxShape.rectangle),
                                    child: tasks[index].isCompleted
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          )
                                        : Container()),
                                title: Text(
                                  tasks[index].title,
                                  style: GoogleFonts.poppins(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            },
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) =>
                ToDoDialog(taskAddController: taskAddController),
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
