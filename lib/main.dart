
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_bookmark/add_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'user.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  String firebaseText = '';
  List<User> users = [];
  int born = 0;

  @override
  void initState() {
    super.initState();
    _fetchFirebaseData();
  }

  void _fetchFirebaseData() async{
    final db = FirebaseFirestore.instance;
    final event = await db.collection("users").get();
    final docs = event.docs;
    final users = docs.map((docs) => User.fromFirestore(docs)).toList();
    setState(() {
      this.users = users;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        children: users.map((user) => ListTile(
          title:Text(user.first),subtitle: Text(user.last),trailing: Text(user.born.toString()),
          onLongPress: () async {
            final db = FirebaseFirestore.instance;
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text('${user.first} ${user.first} を削除しますか??'),
                  actions: [
                    TextButton(
                        child: Text("OK"),
                        onPressed: () {
                          db.collection("users").doc(user.id).delete();
                          _fetchFirebaseData();
                          Navigator.pop(context);
                        }
                    ),
                    TextButton(
                      child: Text("Cancel"),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                );
              },
            );

          },
          onTap: () {
            showDialog(
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
                      initialDate: DateTime(user.born),
                      selectedDate: DateTime(user.born),
                      onChanged: (DateTime dateTime) {
                        FirebaseFirestore.instance.
                        collection("users").doc(user.id).update({'born':dateTime.year});
                        _fetchFirebaseData();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
        ) .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddPage,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _goToAddPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPage()),
    );
    _fetchFirebaseData();
  }
}
