import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:to_do/home_page.dart';

class AddTodo extends StatefulWidget {
  AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  void testFirebase() async {
    FirebaseFirestore.instance.collection('test').add({'name': 'Hy'});
  }

  final CollectionReference tasks =
      FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask() async {
    if (_taskController.text.isEmpty ||
        _descController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _selectedValue == null ||
        _radioSelectedValue == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Incomplete',style: GoogleFonts.poppins(color: Colors.purple, fontSize: 15),),
            content: Text(
              'Please fill all fields',
              style: GoogleFonts.poppins(color: Colors.black, fontSize: 15),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Ok',
                    style:
                        GoogleFonts.poppins(color: Colors.purple, fontSize: 20),
                  ))
            ],
          );
        },
      );
      return;
    }

    return tasks
        .add({
          'task': _taskController.text,
          'desc': _descController.text,
          'date': _dateController.text,
          'priority': _selectedValue,
          'mode': _radioSelectedValue,
          'status': _isCompleted
        }).then((value) {
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              title: Text('Completed',style: GoogleFonts.poppins(color: Colors.purple, fontSize: 15),),
              content: Text('Task added successfully',style: GoogleFonts.poppins(color: Colors.black, fontSize: 15),),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _taskController.clear();
                    _descController.clear();
                    _dateController.clear();
                    _selectedValue = null;
                    _radioSelectedValue = null;
                
                  },
                  child: Text(
                    'Ok',
                    style:
                        GoogleFonts.poppins(color: Colors.purple, fontSize: 20),
                  ))
              ],
            );
          },);
        });
        
  }

  Future<void> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context, firstDate: DateTime(2000), lastDate: DateTime(2101));
    if (pickedDate != null) {
      String formatedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {
        _dateController.text = formatedDate;
      });
    }
  }

  final List<String> _dropDownItems = [
    'High priority',
    'Mediam priority',
    'Less priority'
  ];

  String? _selectedValue;
  String? _radioSelectedValue;
  bool _isCompleted = false;

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
        Column(
          children: <Widget>[
            TextFormField(
              controller: _taskController,
              style: GoogleFonts.poppins(fontSize: 20, color: Colors.black),
              autofocus: true,
              decoration: InputDecoration(
                  hintText: 'Task',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.black,
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _descController,
              style: GoogleFonts.poppins(fontSize: 20, color: Colors.black),
              autofocus: true,
              decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.black,
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              readOnly: true,
              controller: _dateController,
              onTap: () async {
                FocusScope.of(context).requestFocus(new FocusNode());
                pickDate();
              },
              style: GoogleFonts.poppins(fontSize: 20, color: Colors.black),
              autofocus: true,
              decoration: InputDecoration(
                  hintText: 'Select date',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.black,
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(30)),
              child: DropdownButton<String>(
                  hint: Text(
                    'Select priority',
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  iconEnabledColor: Colors.white,
                  dropdownColor: Colors.purple,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  underline: SizedBox.shrink(),
                  value: _selectedValue,
                  style: GoogleFonts.poppins(color: Colors.white),
                  items: _dropDownItems.map((String item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (String? newvalue) {
                    setState(() {
                      _selectedValue = newvalue;
                    });
                  }),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: <Widget>[
                RadioListTile(
                    title: Text(
                      'Personal',
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                    value: 'Personal',
                    activeColor: Colors.purple,
                    groupValue: _radioSelectedValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        _radioSelectedValue = newValue;
                      });
                    }),
                RadioListTile(
                    title: Text(
                      'Work',
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                    value: 'Work',
                    activeColor: Colors.purple,
                    groupValue: _radioSelectedValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        _radioSelectedValue = newValue;
                      });
                    }),
              ],
            ),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                  onPressed: () {
                    addTask();
                  },
                  child: Text(
                    'Add',
                    style: GoogleFonts.poppins(color: Colors.white),
                  )),
            ),
          ],
        )
      ],
    );
  }
}
