import 'package:flutter/material.dart';
import 'package:wha_flutter/speakers.dart';

class WholeHomeAudio extends StatefulWidget {
  @override
  _WholeHomeAudioState createState() => _WholeHomeAudioState();
}

class _WholeHomeAudioState extends State<WholeHomeAudio> {
  final appBar = AppBar(
      title: Text(
    "Whole Home Audio",
    style: TextStyle(fontSize: 18.0),
  ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SpeakerWidget(),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("Settings"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => FirstRoute()));
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: new Container(
        height: 50.0,
        alignment: Alignment.center,
        child: new BottomAppBar(
          child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new IconButton(
                  icon: Icon(Icons.speaker),
                  onPressed: () {},
                ),
                new IconButton(
                  icon: Icon(Icons.record_voice_over),
                  onPressed: () {},
                ),
              ]),
        ),
      ),
    );
  }
}

class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Open route'),
          onPressed: () {
            // Navigate to second route when tapped.
          },
        ),
      ),
    );
  }
}
