import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do/services/to_do_services.dart';

class ToDoDialog extends StatelessWidget {
  const ToDoDialog({super.key, required this.taskAddController});
  final TextEditingController taskAddController;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 19),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Text(
            'Add Task',
            style:
                GoogleFonts.poppins(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.cancel,
                color: Colors.red,
              ))
        ],
      ),
      children: [
        TextFormField(
          controller: taskAddController,
          style: GoogleFonts.poppins(fontSize: 20, color: Colors.black),
          autofocus: true,
          decoration: InputDecoration(
              hintText: 'Eg : Go to Shopping',
              hintStyle: GoogleFonts.poppins(
                color: Colors.black,
              )),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 40,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
              onPressed: () async {
                if (taskAddController.text.isNotEmpty) {
                  await ToDoServices()
                      .createTask(taskAddController.text.trim());
                }
                Navigator.pop(context);
                taskAddController.clear();
              },
              child: Text('Add')),
        )
      ],
    );
  }
}
