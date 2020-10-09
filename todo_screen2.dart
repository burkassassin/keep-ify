import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:notes_secondapp/models/todo2.dart';
import 'package:notes_secondapp/screens/task_screen2.dart';
import 'package:notes_secondapp/services/category_service2.dart';

import 'package:notes_secondapp/services/todo_service2.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var _todoTitleController = TextEditingController();

  var _todoDescriptionController = TextEditingController();

  var _todoDateController = TextEditingController();

  var _selectedValue;

  var _categories = List<DropdownMenuItem>();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

 

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category['name']),
          value: category['name'],
        ));
      });
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
        _todoDateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
    }
  }

  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.tealAccent[400],
        centerTitle: true,
        title: Text(
          'Keep-ify',
          style: TextStyle(color: Colors.black, fontSize: 28,fontFamily: 'Quicksand',),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _todoTitleController,
              decoration: InputDecoration(
                  labelText: 'Title', hintText: 'Write Todo Title'),
            ),
            TextField(
              controller: _todoDescriptionController,
              decoration: InputDecoration(
                  labelText: 'Description', hintText: 'Write Todo Description'),
            ),
            TextField(
              cursorColor: Colors.black,
              controller: _todoDateController,
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
            Expanded(
              child: DropdownButtonFormField(
                value: _selectedValue,
                items: _categories,
                hint: Text('Category'),
                onChanged: (value) {
                  setState(() {
                    _selectedValue = value;
                  });
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
               shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
              onPressed: () async {
                var todoObject = Todo();

                todoObject.title = _todoTitleController.text;
                todoObject.description = _todoDescriptionController.text;
                todoObject.isFinished = 0;
                todoObject.category = _selectedValue.toString();
                todoObject.todoDate = _todoDateController.text;
               

                var _todoService = TodoService();
                var result = await _todoService.saveTodo(todoObject);

                if (result > 0) {
                  _showSuccessSnackBar(Text('Created'));
                }

                print(result);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              color: Colors.tealAccent[400],
              child: Text(
                'Save',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
