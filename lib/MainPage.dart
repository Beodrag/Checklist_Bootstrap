import 'package:flutter/material.dart';
import 'AddPage.dart';
import 'TrashPage.dart';
import 'package:firebase_database/firebase_database.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title, required this.user});

  final String title;
  final String user;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    // Move the Firebase database query logic to initState
    _fetchDataFromFirebase();
  }

  void _fetchDataFromFirebase() {
    FirebaseDatabase.instance.ref().child("Users/" + this.widget.user + "/").once()
        .then((DatabaseEvent event) {
      List<Map<String, dynamic>> tempList = [];
      if (event.snapshot.value != null && event.snapshot.value is Map) {
        // Check if the value is not null and is a Map before using forEach
        (event.snapshot.value as Map).forEach((k, v) {
          print(k);
          print(v);
          tempList.add({
            "message": v["message"] as String,
            "date": v["date"] as String,
            "status": v["status"] as bool,
          });
        });
        data = tempList;
        setState(() {

        });
      }
    }).catchError((error) {
      print(error.toString());
    });
  }



  List<Map<String, dynamic>> trash = [];

  void addItemCallback(Map<String, dynamic>? newItem) {
    if (newItem != null) {
      setState(() {
        data.add(newItem);
      });
    }
  }


  void toggleStatus(int index) {
    setState(() {
      if (data[index]["status"]) {
        // Move the checked task to the trash page
        trash.add(data[index]);
        data.removeAt(index);
      } else {
        data[index]["status"] = !data[index]["status"];
      }
    });
  }

  void _nextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddPage(title: 'Add To-Do', data: data, addItemCallback: addItemCallback, email: this.widget.user),
    ));
  }

  void _trashPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrashPage(
          title: 'Completed',
          trashData: trash, // Pass the updated trashData
        ),
      ),
    );
  }

  TextButton complete(bool dat, int index) {
    return TextButton.icon(
      onPressed: () {
        toggleStatus(index); // Toggle the status when the button is pressed
      },
      icon: Icon(dat ? Icons.check_box : Icons.check_box_outline_blank),
      label: Text(''),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checklist", textAlign: TextAlign.center),
        backgroundColor: Colors.blueGrey,

      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: data.length + 1,
              itemBuilder: (context, index) {
                if (index < data.length) {
                  // Return a ListTile for checklist items
                  return ListTile(
                    leading: complete(data[index]["status"] as bool, index),
                    title: Text(data[index]["message"] as String),
                    trailing: Text(data[index]["date"] as String),
                  );
                } else {
                  // Return a ListTile for the "Add" button
                  return ListTile(
                    leading: ElevatedButton(
                      onPressed: _nextPage,
                      child: Text("+"),
                    ),
                    trailing: ElevatedButton(
                      onPressed: _trashPage,
                      child: Icon(Icons.restore_from_trash),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
