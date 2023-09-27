import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key, required this.title, required this.data, required this.addItemCallback, required this.email});

  final String title;
  final List<Map<String, dynamic>> data;
  final Function(Map<String, dynamic>) addItemCallback;
  final String email;

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController messageController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  void _addItem() {
    // Get the entered values
    String message = messageController.text;
    String date = dateController.text;
    bool status = false;



    // Create a new item

    Map<String, dynamic> newItem = {
      "status": false,
      "message": message,
      "date": date,
    };

    var timestamp = new DateTime.now().millisecondsSinceEpoch;
    FirebaseDatabase.instance.ref().child("Users/" + this.widget.email + "/Task" + timestamp.toString()).set({
      "message": message,
      "date": date,
      "status": status,
    }).then((value) {
      print("Added!");
      Navigator.pop(context);
    }).catchError((error){
      print(error.toString());
    });



    // Call the callback to add the new item to the main page's state
    widget.addItemCallback(newItem);

    // Navigate back to the main page

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, textAlign: TextAlign.center),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: messageController,
              decoration: InputDecoration(labelText: 'Task'),
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Deadline'),
            ),
            ElevatedButton(
              onPressed: _addItem,
              child: Text("Add Item"),
            ),
          ],
        ),
      ),
    );
  }
}
