import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:notes_secondapp/helpers/drawer_navigation2.dart';
import 'package:notes_secondapp/models/todo2.dart';
import 'package:notes_secondapp/screens/todo_screen2.dart';
import 'package:notes_secondapp/services/todo_service2.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TodoService _todoService;

  List<Todo> _todoList = List<Todo>();

  var _editTodoTitleController = TextEditingController();
  var _editTodoDescriptionController = TextEditingController();
  var _editDateController = TextEditingController();

  var todo;

  var _todo = Todo();

  @override
  initState() {
    super.initState();
    getAllTodos();
  }

  getAllTodos() async {
    _todoService = TodoService();
    _todoList = List<Todo>();

    var todos = await _todoService.readTodos();

    todos.forEach((todo) {
      setState(() {
        var model = Todo();
        model.id = todo['id'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.category = todo['category'];
        model.todoDate = todo['todoDate'];
        model.isFinished = todo['isFinished'];

        _todoList.add(model);
      });
    });
  }

  _editTodo(BuildContext context, taskId) async {
    todo = await _todoService.readTodosById(taskId);
    setState(() {
      _editTodoTitleController.text = todo[0]['name'] ?? 'No Name';
      _editTodoDescriptionController.text =
          todo[0]['description'] ?? 'No Description';
    });
    _editFormDialog(context);
  }

  _editFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(20),
            ),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.tealAccent[400],
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.tealAccent[400],
                onPressed: () async {
                  _todo.id = todo[0]['id'];
                  _todo.title = _editTodoTitleController.text;
                  _todo.description = _editTodoDescriptionController.text;
                  _todo.todoDate = _editDateController.text;

                  var result = await _todoService.updateTodo(_todo);
                  if (result > 0) {
                    Navigator.pop(context);
                    getAllTodos();
                  }
                },
                child: Text(
                  'Update',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
            title: Text('Edit Your Task'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _editTodoTitleController,
                    decoration: InputDecoration(
                        hintText: 'Change the Title', labelText: 'Title'),
                  ),
                  TextField(
                    controller: _editTodoDescriptionController,
                    decoration: InputDecoration(
                        hintText: 'Change the Description',
                        labelText: 'Description'),
                  ),
                  TextField(
                    controller: _editDateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      hintText: 'Pick a Date',
                      prefixIcon: InkWell(
                        onTap: () {
                          _selectedTodoDate(context);
                        },
                        child: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  DateTime _dateTime = DateTime.now();
  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate;
        _editDateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.tealAccent[400],
        title: Text(
          'Keep-ify',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontFamily: 'Quicksand',
          ),
        ),
      ),
      drawer: DrawerNavigaton(),
      body: ListView.builder(
          itemCount: _todoList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
              child: Card(
                  elevation: 12,
                  shadowColor: Colors.tealAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(_todoList[index].title ?? 'No Title'),
                        IconButton(
                            color: Colors.white,
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _editTodo(context, _todoList[index].id);
                            })
                      ],
                    ),
                    subtitle:
                        Text(_todoList[index].description ?? 'No Description'),
                    trailing: Text(_todoList[index].todoDate ?? 'No Date'),
                    onLongPress: () {
                      setState(() {
                        _deleteFormDialog(context, _todoList[index].id);
                      });
                    },
                  )),
            );
          }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 160),
        child: FloatingActionButton(
            backgroundColor: Colors.tealAccent[400],
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => TodoScreen())),
            child: Icon(
              Icons.add,
              color: Colors.black,
            )),
      ),
    );
  }

  _deleteFormDialog(BuildContext context, taskId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(20),
            ),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.tealAccent[400],
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.tealAccent[400],
                onPressed: () async {
                  var result = await _todoService.deleteTask(taskId);
                  setState(() {
                    if (result > 0) {
                      Navigator.pop(context);
                      getAllTodos();
                    }
                  });
                },
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
            title: Text('Are you sure you want to delete this?'),
          );
        });
  }
}
