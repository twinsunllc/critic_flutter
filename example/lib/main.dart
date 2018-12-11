import 'package:flutter/material.dart';
import 'dart:async';

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
    Critic().initialize('gJ44GxttrahyVBFs4k3jb8T1');
    super.initState();
  }

  void _submitReport() {
    BugReport report = BugReport.create(
        description: _descriptionController.text,
        stepsToReproduce: _reproduceController.text);
    Critic().submitReport(report).then((BugReport successfulReport) {
      _showPopupSuccess(successfulReport.description, successfulReport.stepsToReproduce);
    }).catchError(
      (Object error){
        print(error.toString());
      }
    );
  }

  void _showPopupSuccess(String desc, String steps) {
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(desc),
                  Text(steps),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cool'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
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
              onPressed: _submitReport,
            ),
          ],
        ),
      ),
    );
  }
}
