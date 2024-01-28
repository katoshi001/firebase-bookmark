import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddPage extends StatelessWidget {
  AddPage({super.key});

  String first = '';
  String last = '';

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
      "born": 1991
    };

    // Add a new document with a generated ID
    db.collection("users").add(user);
  }

}
