import 'package:notes_secondapp/models/todo2.dart';

import 'package:notes_secondapp/repositories/repository2.dart';

class TodoService {
  Repository _repository;

  TodoService() {
    _repository = Repository();
  }

  // create todos
  saveTodo(Todo todo) async {
    return await _repository.insertData('todos', todo.todoMap());
  }

  // read todos
  readTodos() async {
    return await _repository.readData('todos');
  }

  // read todos by category
  readTodosByCategory(category) async {
    return await _repository.readDataByColumnName(
        'todos', 'category', category);
  }

  readTodosById(taskId) async {
    return await _repository.readDataById('todos', taskId);
  }

   updateTodo(Todo todo) async {
    return await _repository.updateData('todos', todo.todoMap());
  }


  deleteTask(taskId) async {
    return await _repository.deleteTodo('todos', taskId);
  }
}
