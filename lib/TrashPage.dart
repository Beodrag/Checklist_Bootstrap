import 'package:flutter/material.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key, required this.title, required this.trashData});


  final String title;
  final List<Map<String, dynamic>> trashData;

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(


          children: <Widget>[
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: widget.trashData.length,
              itemBuilder: (context, index){
                return ListTile(
                  title: Text(widget.trashData[index]["message"] as String),
                  trailing: Text(widget.trashData[index]["date"] as String),
                );
              },
            ),
            ElevatedButton(onPressed: (){widget.trashData.clear();setState(() {});}, child: Text("Clear")),
          ],
        ),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}