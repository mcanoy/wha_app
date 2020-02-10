import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LetsTalk extends StatefulWidget {
  @override
  _LetsTalkState createState() => _LetsTalkState();
}

class _LetsTalkState extends State<LetsTalk> {
  final _formKey = GlobalKey<FormState>();
  var _phrase;

  void _googleSay() {
    print("google say $_phrase");
    http.get("http://home-pi.local:8181/google/talk?phrase=$_phrase");
  }

  void _ronSwanson() {
    http.get("https://ron-swanson-quotes.herokuapp.com/v2/quotes")
    .then((response) => {
        setState(() {
          _phrase = "Ron Swanson says " + json.decode(response.body)[0];
          _googleSay();
      })
    });
  }

  void _nextGame(var team) {
    http.get("http://home-pi.local:8181/next/$team");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppBar(
                leading: Icon(Icons.verified_user),
                elevation: 0,
                title: Text('Google Say'),
                backgroundColor: Colors.blue[500],
                centerTitle: true,
                actions: <Widget>[  
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {},
                  )
                ],
              ),
              TextFormField(
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
              SizedBox(height: 10,),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Translating...')));
                      _formKey.currentState.save();
                      _googleSay();
                    }
                  },
                  color: Colors.blue,
                  child: Text('Say', style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 20,),
              AppBar(
                leading: Icon(Icons.verified_user),
                elevation: 0,
                title: Text('Direct Hits'),
                backgroundColor: Colors.blue[500],
                centerTitle: true,
                actions: <Widget>[  
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {},
                  )
                ],
              ),
              SizedBox(height: 10,),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () {
                      _nextGame("leafs");

                  },
                  color: Colors.blue[50],
                  child: Text('Leafs', style: TextStyle(color: Colors.blue)),
                ),
              ),
              SizedBox(height: 2,),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () {
                      _nextGame("raptor");

                  },
                  color: Colors.white,
                  child: Text('Raptors', style: TextStyle(color: Colors.purple)),
                ),
              ),
              SizedBox(height: 2,),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () {
                      _ronSwanson();

                  },
                  color: Colors.white,
                  child: Text('Ron Swanson', style: TextStyle(color: Colors.red)),
                ),
              ),
            ],
          )),
          
    );
  }
}
