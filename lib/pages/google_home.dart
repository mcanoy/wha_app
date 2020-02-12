import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LetsTalk extends StatefulWidget {
  @override
  _LetsTalkState createState() => _LetsTalkState();
}

class _LetsTalkState extends State<LetsTalk> {
  final form = GlobalKey<FormState>();
  var _phrase;

  void _googleSay() {
    print("google say $_phrase");
    http.get("http://home-pi.local:8181/google/talk?phrase=$_phrase");
  }

  void _nextGame(var team) {
    print(team);
    if (team == "ron swanson") {
      http
          .get("https://ron-swanson-quotes.herokuapp.com/v2/quotes")
          .then((response) => {
                setState(() {
                  _phrase = "Ron Swanson says " + json.decode(response.body)[0];
                  _googleSay();
                })
              });
    } else {
      http.get("http://home-pi.local:8181/next/$team");
    }
  }

  Padding _createButton(String label, Color c) {

    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8),
      child: Row(
        //padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
        children: [
          Expanded(
            child: RaisedButton(
              onPressed: () {
                _nextGame(label.toLowerCase());
              },
              color: c,
              child: Text(label, style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Material(
            elevation: 1,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(8),
            child: Form(
              key: form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AppBar(
                    leading: Icon(Icons.verified_user),
                    elevation: 0,
                    title: Text('Google Say'),
                    backgroundColor: Colors.grey[700],
                    centerTitle: true,
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {},
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(Icons.mic),
                        labelText: 'Google Say This',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Don't forget to enter something to say";
                        }
                        return null;
                      },
                      onSaved: (val) => _phrase = val,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                    child: Row(
                      //padding: EdgeInsets.only(left: 16, right: 16, bottom: 24),
                      children: [
                        Expanded(
                          child: RaisedButton(
                            onPressed: () {
                              if (form.currentState.validate()) {
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text('Translating...')));
                                form.currentState.save();
                                _googleSay();
                              }
                            },
                            color: Colors.blue,
                            child: Text('Say',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              children: <Widget>[
                Material(
                  elevation: 1,
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AppBar(
                        leading: Icon(Icons.done),
                        elevation: 0,
                        title: Text('Quick Hits'),
                        backgroundColor: Colors.grey[700],
                        centerTitle: true,
                        actions: <Widget>[
                          IconButton(
                            icon: Icon(Icons.account_balance),
                            onPressed: () {},
                          )
                        ],
                      ),
                      _createButton("Leafs", Colors.blue[400]),
                      _createButton("Raptors", Colors.blue[500]),
                      _createButton("Birthday", Colors.blue[600]),
                      _createButton("Ron Swanson", Colors.blue[700]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
