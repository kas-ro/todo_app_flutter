import 'package:flutter/material.dart';
import 'package:todo_app/data/db_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Todo App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> _todos = [];
  final _controller = TextEditingController();

  void _addTask() async {
    if (_controller.text.isNotEmpty) {
      DbHelper.insertData(_controller.text);
      _controller.clear();
      _fetchAllData();
    }
  }

  void _updateTask(int id, int done) async {
    await DbHelper.updateData(id, done == 0 ? 1 : 0);
    _fetchAllData();
  }

  void _deleteTask(int id) async {
    await DbHelper.deleteData(id);
    _fetchAllData();
  }

  void _fetchAllData() async {
    final data = await DbHelper.getAllData();
    setState(() {
      _todos = data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
            widget.title,
            style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                    hintText: 'Saisissez la tâche',
                    border: OutlineInputBorder()),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      final todo = _todos[index];
                      return ListTile(
                        onLongPress: () {_deleteTask(todo['id']);},
                        title: Text(
                            todo['task'],
                            style: TextStyle(decoration:  todo['done'] == 1 ? TextDecoration.lineThrough : TextDecoration.none)
                        ),
                        subtitle: Text(todo.toString()),
                        trailing: Checkbox(
                            value: todo['done'] == 1,
                            onChanged: (value){
                              _updateTask(todo['id'], todo['done']);
                            },
                        ),
                      );
                    }))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTask();
        },
        tooltip: 'Ajouter des tâches',
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white,),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
