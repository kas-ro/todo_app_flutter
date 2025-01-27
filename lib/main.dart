import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/data/db_helper.dart';
import 'package:todo_app/pages/add_task.dart';

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
      home: const MyHomePage(title: 'Ma liste de tâches'),
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
  int _count = 0;

  void _addTask() async {
    if (_controller.text.isNotEmpty) {
      final DateTime createdAt = DateTime.now();
      int date = createdAt.millisecondsSinceEpoch;
      DbHelper.insertData(_controller.text, date);
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
    List<Map<String, dynamic>> datas = [];
    int i = 0;
    for (var row in data.reversed) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(row['createdAt']);
      datas.insert(i, {
        'id': row['id'],
        'task': row['task'],
        'done': row['done'],
        'createdAt': date,
      });
      i++;
    }
    setState(() {
      _todos = datas;
    });
  }

  void _alertDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Incrementation"),
            content: Text("Etes vous sur de vouloir incrementer"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Annuler")
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _count++;
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Confirmer")
              ),
            ],
          );
        }
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  Future<void> _navigateToAddOrEditTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTask()),
    );

    if (result) { // Si une tâche a été ajoutée ou modifiée
      _fetchAllData(); // Recharger les tâches
    }
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
                        subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(todo['createdAt'])),
                        trailing: Checkbox(
                            value: todo['done'] == 1,
                            onChanged: (value){
                              _updateTask(todo['id'], todo['done']);
                            },
                        ),
                      );
                    },
                ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddOrEditTask();
        },
        tooltip: 'Ajouter des tâches',
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white,),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
