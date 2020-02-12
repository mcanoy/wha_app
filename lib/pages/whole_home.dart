import 'package:flutter/material.dart';

import 'package:wha_flutter/model/pages.dart';
import 'package:wha_flutter/pages/google_home.dart';
import 'package:wha_flutter/pages/settings.dart';
import 'package:wha_flutter/pages/speakers.dart';
import 'package:wha_flutter/test.dart';
import 'package:wha_flutter/test2.dart';

class WholeHomeAudio extends StatefulWidget {
  @override
  _WholeHomeAudioState createState() => _WholeHomeAudioState();
}

class _WholeHomeAudioState extends State<WholeHomeAudio> {
  var _selectedIndex = 0; //default
  final List<Page> _screens = [
    Page("Whole Home Audio", SpeakerWidget(), 0, Icons.speaker),
    Page("Let's Talk", LetsTalk(), 1, Icons.record_voice_over),
    Page("Test", TestWidget(), 2, Icons.ac_unit),
    Page("Test 2", MyApp(), 3, Icons.receipt),
  ];

  void setIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _bottomNavItems() {
    List<Widget> navItems = new List<Widget>();
    for (Page p in _screens) {
      navItems.add(IconButton(
        icon: Icon(p.iconData),
        onPressed: () {
          setIndex(p.index);
        },
      ));
    }

    return navItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        _screens[_selectedIndex].title,
        style: TextStyle(fontSize: 18.0),
      )),
      body: _screens[_selectedIndex].widget,
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("Zone Settings"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => SettingsWidget()));
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: new Container(
        height: 70.0,
        alignment: Alignment.center,
        child: new BottomAppBar(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _bottomNavItems(),
          ),
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
