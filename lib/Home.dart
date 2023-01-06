
import 'package:assignment_3/db_helper.dart';
import 'package:assignment_3/grocery.dart';
import 'package:flutter/material.dart';

class SqliteApp extends StatefulWidget {
  const SqliteApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SqliteAppState createState() => _SqliteAppState();
}

class _SqliteAppState extends State<SqliteApp> {
  int? selectedId;
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: TextField(
            decoration: const InputDecoration(
            labelText: 'Basic CRUD w/Sqflite package' ),
          controller: textController,
          ),
        ),
        body: Center(
          child: FutureBuilder<List<Grocery>>(
              future: DatabaseHelper.instance.getGroceries(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Grocery>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: Text('Loading...'));
                }
                return snapshot.data!.isEmpty
                    ?const Center(child: Text("Type in AppBar to add grocery list."))
                    : ListView(
                  children: snapshot.data!.map((grocery) {
                    return Center(
                      child: Card(
                        color: selectedId == grocery.id
                            ? Colors.white70
                            : Colors.white,
                        child: ListTile(
                          title: Text(grocery.name),
                          onTap: () {
                            setState(() {
                              if (selectedId == null) {
                                textController.text = grocery.name;
                                selectedId = grocery.id;
                              } else {
                                textController.text = '';
                                selectedId = null;
                              }
                            });
                          },
                          onLongPress: () {
                            setState(() {
                              DatabaseHelper.instance.remove(grocery.id!);
                            });
                          },
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child:const Icon(Icons.save),
          onPressed: () async {
            selectedId != null
                ? await DatabaseHelper.instance.update(
              Grocery(id: selectedId, name: textController.text),
            )
                : await DatabaseHelper.instance.add(
              Grocery(name: textController.text),
            );
            setState(() {
              textController.clear();
              selectedId = null;
            });
          },
        ),
    );
  }
}