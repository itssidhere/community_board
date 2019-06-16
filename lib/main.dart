import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'model/board.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Community Board',
      theme: ThemeData(
        cursorColor: Color(0xFFFFF),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Board board;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DatabaseReference databaseReference;

  @override
  void initState() {
    super.initState();

    board = Board("", "");
    databaseReference = database.reference().child("community_board");
    databaseReference.onChildAdded.listen(_onEntryAdded);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Community Board"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: [Colors.blue[900], Colors.red])),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/community.jpg"), fit: BoxFit.cover),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
                primaryColor: Colors.green, hintColor: Colors.blue[50]),
            child: Column(children: <Widget>[
              Flexible(
                flex: 0,
                child: Form(
                  key: formKey,
                  child: Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: TextFormField(
                            style: TextStyle(color: Colors.white),
                            initialValue: "",
                            onSaved: (val) => board.subject = val,
                            validator: (val) => val == "" ? val : null,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.subject,
                                  color: Colors.white,
                                ),
                                labelText: "Enter the Subject",
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: TextFormField(
                            style: TextStyle(color: Colors.white),
                            initialValue: "",
                            onSaved: (val) => board.body = val,
                            validator: (val) => val == "" ? val : null,
                            decoration: InputDecoration(
                                prefixIcon:
                                    Icon(Icons.message, color: Colors.white),
                                labelText: "Enter the Body",
                                labelStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.blue[900], Colors.red]),
                          ),
                          child: FlatButton(
                            child: Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              handleSubmit();
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Flexible(
                child: FirebaseAnimatedList(
                    query: databaseReference,
                    itemBuilder: (context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      return new Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.red,
                          ),
                          title: Text(
                            snapshot.value['subject'],
                          ),
                          subtitle: Text(snapshot.value['body']),
                        ),
                      );
                    }),
              )
            ] // This trailing comma makes auto-formatting nicer for build methods.
                ),
          ),
        ));
  }

  void _onEntryAdded(Event event) {
//    setState(() {
//    });
  }

  void handleSubmit() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      form.reset();

      databaseReference.push().set(board.toJson());
    }
  }



}
