import 'package:flutter/material.dart';

import 'package:notes_secondapp/screens/categories_screen2.dart';

import 'package:notes_secondapp/screens/task_screen2.dart';

import 'package:notes_secondapp/screens/todos_by_category2.dart';

import 'package:notes_secondapp/services/category_service2.dart';

class DrawerNavigaton extends StatefulWidget {
  @override
  _DrawerNavigatonState createState() => _DrawerNavigatonState();
}

class _DrawerNavigatonState extends State<DrawerNavigaton> {
  List<Widget> _categoryList = List<Widget>();

  CategoryService _categoryService = CategoryService();

  @override
  initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    var categories = await _categoryService.readCategories();

    categories.forEach((category) {
      setState(() {
        _categoryList.add(InkWell(
          onTap: () => Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new TodosByCategory(
                        category: category['name'],
                      ))),
          child: ListTile(
            title: Text(
              category['name'],
              style: TextStyle(fontSize: 16),
            ),
          ),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: Container(
          color: Colors.tealAccent[400],
          child: ListView(
            children: <Widget>[
              /*
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcReESg1I_zS8o7w3pIlek4xSp40-TtFhWcyCh_Xv7HsqhnExuI1&usqp=CAU'),
                ),
                accountName: Text('Abdul Aziz Ahwan'),
                accountEmail: Text('admin@abdulazizahwan'),
                decoration: BoxDecoration(color: Colors.blue),
              ),*/
              ListTile(
                leading: Icon(Icons.done_all,color: Colors.black,),
                title: Text(
                  'Keep-home',
                  style: TextStyle(fontSize: 25, color: Colors.black,fontFamily: 'Quicksand',),
                ),
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreen())),
              ),
              ListTile(
                leading: Icon(Icons.view_list,color: Colors.black,),
                title: Text(
                  'CategoryCreator',
                  style: TextStyle(fontSize: 25, color: Colors.black,fontFamily: 'Quicksand',),
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CategoriesScreen())),
              ),
              Column(
                children: _categoryList,
              ),
            ],
          ),
        ),
        
      ),
    );
  }
}
