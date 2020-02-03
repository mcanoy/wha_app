import 'package:flutter/material.dart';
import 'package:wha_flutter/whole_home.dart';


void main() => runApp(WholeHomeAudioApp());

class WholeHomeAudioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Whole Home Audio",
      theme: ThemeData(primarySwatch: Colors.blue, accentColor: Colors.blue[800]),
      home: WholeHomeAudio());
  }
}
