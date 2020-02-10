import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wha_flutter/model/settings_model.dart';
import 'package:wha_flutter/whole_home.dart';

void main() => runApp(WholeHomeAudioApp());

class WholeHomeAudioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsNotifier>(
      create: (_) => SettingsNotifier(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Whole Home Audio",
          theme: ThemeData(
              primarySwatch: Colors.blue, accentColor: Colors.blue[800]),
          home: WholeHomeAudio()),
    );
  }
}
