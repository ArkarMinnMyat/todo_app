import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_page.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/utils/snackbar_helper.dart';
import 'package:todo_app/widget/todo_cart.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {

  bool isLoading = true;
  List items = []; 
  @override
  void initState() {
    super.initState();
    fetchTodo();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List',),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text('No Todo Item',
              style: Theme.of(context).textTheme.headlineMedium,),),
            child: ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index){
              final item = items[index] as Map;
              final id = item['_id'];
              return TodoCart(index: index, item: item, navigateEdit: navigateToEditPage, deleteById: deleteById);},),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage, 
        label: Text('Add Todo')
      ),
    );
  }

  Future<void> navigateToAddPage() async{
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToEditPage(Map item) async{
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item,),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }
  

  Future<void> deleteById(String id) async {
    final isSuccess = await TodoService.deleteById(id);

    if(isSuccess){
      final filtered = items.where((element) => element['_id'] != id).toList();
      showSuccessMessage(context, message: 'Delete Successful');
      setState(() {
        items = filtered;
      });
    }else {
      showErrorMessage(context ,message: 'Delete fail');
    }
  }

  Future<void> fetchTodo() async {

    final response = await TodoService.fetchTodo();
    if(response != null){
      
      setState(() {
        items = response;
      });
    } else {
      showErrorMessage(context ,message: 'Something went wrong');
    } 
    setState(() {
      isLoading = false;
    });
  }

    
}