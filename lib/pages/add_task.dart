import 'package:flutter/material.dart';

import '../data/db_helper.dart';

class AddTask extends StatelessWidget {
   AddTask({super.key});

  final _controller = TextEditingController();

   void _addTask(BuildContext context) async {
     if (_controller.text.isNotEmpty) {
       final DateTime createdAt = DateTime.now();
       int date = createdAt.millisecondsSinceEpoch;
       DbHelper.insertData(_controller.text, date);
       _controller.clear();
       Navigator.pop(context, true);
     }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Ajouter une tache',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(17),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        labelText: 'Saisissez la tâche',
                        border: OutlineInputBorder()),
                  ),
              ),
              ElevatedButton(
                  onPressed: (){
                    _addTask(context);
                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder( // Forme du bouton
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: TextStyle(fontSize: 15,)
                  ),
                  child: Text('Enregistrer')

              )
            ],
          )
      ),
    );
  }
}