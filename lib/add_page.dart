import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  String first = '';
  String last = '';
  int born = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                  hintText: 'FirstName'
              ),
              onChanged: (text) {
                first = text;
              },
            ),
            TextField(
              decoration: const InputDecoration(
                  hintText: 'LastName'
              ),
              onChanged: (text) {
                last = text;
              },
            ),
            Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                  ),
                  child: SizedBox(
                    width: 300,
                    child: Text(
                        born != 0 ? born.toString() :'Born',
                      style:TextStyle(
                          color: born!= 0? Colors.black : Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Select Year"),
                        content: Container(
                          width: 300,
                          height: 300,
                          child: YearPicker(
                            firstDate: DateTime(DateTime.now().year - 100, 1),
                            lastDate: DateTime(DateTime.now().year + 100, 1),
                            initialDate: DateTime(DateTime.now().year),
                            selectedDate: DateTime(born),
                            onChanged: (DateTime dateTime) {
                              setState(() {
                                born = dateTime.year;
                              });
                              // Navigator.pop(context);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                await _addToFirebase();
                Navigator.pop(context);
              },
              child: const Text('追加する'),
            )
          ],
        ),
      ),
    );
  }

  Future _addToFirebase() async {
    final db = FirebaseFirestore.instance;

    // Create a new user with a first and last name
    final user = <String, dynamic>{
      "first": first,
      "last": last,
      "born": born,
    };
    // Add a new document with a generated ID
    db.collection("users").add(user);
  }
}

