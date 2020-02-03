import 'package:flutter/material.dart';

class SpeakerShortCuts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
                  icon: Icon(Icons.power_settings_new),
                  color: Colors.blue[800],
                  onPressed: () {
                    print("ayo");
                  },
                );
  }
}