import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wha_flutter/zones.dart';

class Speaker2Widget extends StatefulWidget {
  @override
  _Speaker2WidgetState createState() => _Speaker2WidgetState();
}

class _Speaker2WidgetState extends State<Speaker2Widget> {
  var _zones = new List<Zone>();
  Color c = Colors.blue[800];

  @override
  void initState() {
    super.initState();
    this._getZones();
  }

  void _toggleZoneProperty(int index, String property) {
    print("toggle");
    Zone zone = _zones[index];
    var toggleValue = "";
    if (property == "pr") {
      toggleValue = zone.power;
    } else if (property == "mu") {
      toggleValue = zone.mute;
    }

    toggleValue = toggleValue == "00" ? "01" : "00";
    print("toggle $property $toggleValue");

    ZoneAPI.changeZone(_zones[index].zone, property, toggleValue)
        .then((response) => _getZones());
  }

  void _adjustVolume(int index, int adjustment) async {
    print("volume adjust $adjustment");
    ZoneAPI.changeZone(
            _zones[index].zone, "vo", _zones[index].powerAdjust(adjustment))
        .then((response) => _getZones());
  }

  void _adjustChannel(int index, int adjustment) async {
    print("channel adjust $adjustment");

    ZoneAPI.changeZone(
            _zones[index].zone, "ch", _zones[index].channelAdjust(adjustment))
        .then((response) => _getZones());
  }

  void _getZones() async {
    print('_getZones');
    await ZoneAPI.getZones().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        _zones = list.map((model) => Zone.fromJson(model)).toList();
        print(_zones.length);

        if (_zones == null) {
          _zones = [];
        }
      });
    });
  }

  var _zoneNameMap = {
    "11": "Den",
    "12": "Office",
    "13": "Living",
    "14": "Dining",
    "15": "Bed",
    "16": "Bath"
  };

  String _getName(int index) {
    Zone zone = _zones[index];
    return _zoneNameMap[zone.zone];
  }

  bool isPowerOn(int index) {
    return _zones[index].power == "01";
  }

  Color _getPowerColor(index) {
    return _zones[index].power == "00" ? Colors.grey[400] : c;
  }

  Color _toggleColor(index) {
    Zone zone = _zones[index];
    return zone.power == "00" || zone.mute == "01" ? Colors.grey[400] : c;
  }

  IconButton _getMuteButton(index) {
    return IconButton(
      icon: Icon(
          _zones[index].mute == "01" ? Icons.volume_off : Icons.volume_mute),
      onPressed: () {
        if (isPowerOn(index)) {
          _toggleZoneProperty(index, "mu");
        }
        ;
      },
      color: _toggleColor(index),
    );
  }

  Container _getVolumeButton(index, IconData volume) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: c,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(volume),
        onPressed: () {
          if (isPowerOn(index)) {
            Icons.volume_up == volume
                ? _adjustVolume(index, 1)
                : _adjustVolume(index, -1);
          }
          ;
        },
        color: _getPowerColor(index),
      ),
    );
  }

  Container _getChannelButton(index, IconData channel) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: c,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(channel),
        onPressed: () {
          if (isPowerOn(index)) {
            Icons.skip_previous == channel
                ? _adjustChannel(index, -1)
                : _adjustChannel(index, 1);
          }
        },
        color: _getPowerColor(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _zones.length,
      itemBuilder: (context, index) => Card(
        child: ExpansionTile(
          leading: IconButton(
              icon: Icon(Icons.power_settings_new),
              color: _getPowerColor(index),
              onPressed: () {
                print("power switch");
                _toggleZoneProperty(index, "pr");
              }),
          trailing: CircleAvatar(
            backgroundColor: Colors.blue[200],
            child: Text(
              _zones[index].volume,
            ),
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _getName(index),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          children: <Widget>[
            Divider(
              color: Colors.grey[300],
              thickness: 2,
            ),
            Row(
              //Status
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: c,
                    ),
                    borderRadius: BorderRadius.circular(90),
                  ),
                  child: Icon(
                    Icons.mic,
                    color: c,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  _zones[index].volume,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25.0, color: c),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: c,
                    ),
                    borderRadius: BorderRadius.circular(90),
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: c,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  _zones[index].channel,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25.0, color: c),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                // Volume + source
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: c,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _getMuteButton(index),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  _getVolumeButton(index, Icons.volume_down),
                  SizedBox(
                    width: 10,
                  ),
                  _getVolumeButton(index, Icons.volume_up),
                  SizedBox(
                    width: 10,
                  ),
                  _getChannelButton(index, Icons.skip_previous),
                  SizedBox(
                    width: 10,
                  ),
                  _getChannelButton(index, Icons.skip_next),
                  //IconButton(icon: Icon(Icons.volume_up), color: Colors.blue[800], onPressed: () {},),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
