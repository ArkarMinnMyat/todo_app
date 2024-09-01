import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/screens/todo_list.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    super.key,
    this.todo
    });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if(todo != null){
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          SizedBox(height: 20,),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData, 
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                isEdit ? 'Update' : 'Submit'),
            ),)
        ],
      ),
    );
  }

  Future<void> updateData() async {
     //get data from form
     final todo = widget.todo;
     if(todo == null){
      print('You cannot update without any data');
      return;
     }
     final id = todo['_id'];
  

    //Update data to the sever
    final isSuccess = await TodoService.updateTodo(id, body);

    //show success or fail message base on status

    if(isSuccess){
      showSuccessMessage(context,message: 'Update Successful');
    }else{
      showErrorMessage(context,message: 'Update Fail');
    }
  }
  Future<void> submitData() async {

    //get data from form

    //submit data to the sever
    final isSuccess = await TodoService.addTodo(body);

    //show success or fail message base on status

    if(isSuccess){
      showSuccessMessage(context,message: 'Creation Successful');
    }else{
      showErrorMessage(context,message: 'Creation Fail');
    }
  }
    Map get body {
      final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
      "is_completed": false
    };
    }
}