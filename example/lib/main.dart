import 'package:flutter/material.dart';

import 'package:inventiv_critic_flutter/critic.dart';
import 'package:inventiv_critic_flutter/modal/bug_report.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController _descriptionController = new TextEditingController(),
      _reproduceController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    Critic().initialize('gJ44GxttrahyVBFs4k3jb8T1');
  }

  void _submitReport(BuildContext context) {
    BugReport report = BugReport.create(
        description: _descriptionController.text,
        stepsToReproduce: _reproduceController.text);
    Critic().submitReport(report).then((BugReport successfulReport) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text('Bug Report has been filed, check console'),
      ));
      print(
          'Successfully logged!\ndescription: ${successfulReport.description}\nsteps to reproduce: ${successfulReport.stepsToReproduce}');
    }).catchError((Object error) {
      print(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Builder(
            builder: (context) => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Enter a description'),
                    TextField(
                      controller: _descriptionController,
                    ),
                    Text('Enter steps to reproduce'),
                    TextField(
                      controller: _reproduceController,
                    ),
                    MaterialButton(
                      color: Colors.grey,
                      onPressed: () {
                        _submitReport(context);
                      },
                      child: Text('Test Submit'),
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
