
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wha_flutter/model/settings_model.dart';
import 'package:wha_flutter/model/zones.dart';
import 'package:wha_flutter/pages/settings.dart';

class SpeakerWidget extends StatefulWidget {
  @override
  _SpeakerWidgetState createState() => _SpeakerWidgetState();
}

class _SpeakerWidgetState extends State<SpeakerWidget> {
  Color c = Colors.blue[800];
  //String baseUrl;

  @override
  void initState() {
    super.initState();
    // SharedPreferences.getInstance().then((SharedPreferences sp) {
    //   baseUrl = sp.getString(SettingsNotifier.BASE_URL);
    //   _getZones();
    // });
  }

  void _toggleZoneProperty(String url, Zone zone, String property) {
    var toggleValue = "";
    if (property == "pr") {
      toggleValue = zone.power;
    } else if (property == "mu") {
      toggleValue = zone.mute;
    }

    toggleValue = toggleValue == "00" ? "01" : "00";
    print("speakers.dart toggle $property $toggleValue");
    ZoneAPI.changeZone(url, zone.zone, property, toggleValue)
        .then((response) => _getZones());
  }

  void _adjustVolume(String url, Zone zone, int adjustment) async {
    print("volume adjust $adjustment");
    ZoneAPI.changeZone(url, zone.zone, "vo",
            zone.powerAdjust(adjustment))
        .then((response) => _getZones());
  }

  void _adjustChannel(String url, Zone zone, int adjustment) async {
    print("speakers.dart channel adjust $adjustment");

    ZoneAPI.changeZone(url, zone.zone, "ch",
            zone.channelAdjust(adjustment))
        .then((response) => _getZones());
  }

  void _getZones() {
    SettingsNotifier note = Provider.of<SettingsNotifier>(context, listen: false);
    note.refreshZones();
  }

  bool isPowerOn(Zone zone) {
    return zone.power == "01";
  }

  Color _getPowerColor(Zone zone) {
    return zone.power == "00" ? Colors.grey[400] : c;
  }

  Color _toggleColor(Zone zone) {
    return zone.power == "00" || zone.mute == "01" ? Colors.grey[400] : c;
  }

  IconButton _getMuteButton(String url, Zone zone) {
    return IconButton(
      icon: Icon(
          zone.mute == "01" ? Icons.volume_off : Icons.volume_mute),
      onPressed: () {
        if (isPowerOn(zone)) {
          _toggleZoneProperty(url, zone, "mu");
        }
      },
      color: _toggleColor(zone),
    );
  }

  Container _getVolumeButton(String url, Zone zone, IconData volume) {
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
          if (isPowerOn(zone)) {
            Icons.volume_up == volume
                ? _adjustVolume(url, zone, 1)
                : _adjustVolume(url, zone, -1);
          }
        },
        color: _getPowerColor(zone),
      ),
    );
  }

  Container _getChannelButton(String url, Zone zone, IconData channel) {
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
          if (isPowerOn(zone)) {
            Icons.skip_previous == channel
                ? _adjustChannel(url, zone, -1)
                : _adjustChannel(url, zone, 1);
          }
        },
        color: _getPowerColor(zone),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Consumer<SettingsNotifier>(builder: (_, settings, __) {
      print("speakers.dart ${settings.baseUrl} zone list ${settings.zoneList}");
      if (settings.baseUrl == null) {
        return SettingsWidget();
      }

      if (settings.baseUrl == "nada" || settings.zoneList == null) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Show you app logo here'),
              CircularProgressIndicator(),
            ],
          ),
        );
      }

      return ListView.builder(
      itemCount: settings.zoneList.length,
      itemBuilder: (context, index) => Card(
        child: ExpansionTile(
          leading: IconButton(
              icon: Icon(Icons.power_settings_new),
              color: _getPowerColor(settings.zoneList[index]),
              onPressed: (() => _toggleZoneProperty(settings.baseUrl, settings.zoneList[index], "pr"))),
          trailing: CircleAvatar(
            backgroundColor: Colors.blue[200],
            child: Text(
              settings.zoneList[index].volume,
            ),
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Consumer<SettingsNotifier>(
                    builder: (_, settings, __) => Text(
                      settings.getZoneLabel(index)?? "Zone ${settings.zoneList[index].zone}"
                      ,style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
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
                  settings.zoneList[index].volume,
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
                  settings.zoneList[index].channel,
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
                    child: _getMuteButton(settings.baseUrl, settings.zoneList[index]),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  _getVolumeButton(settings.baseUrl, settings.zoneList[index], Icons.volume_down),
                  SizedBox(
                    width: 10,
                  ),
                  _getVolumeButton(settings.baseUrl, settings.zoneList[index], Icons.volume_up),
                  SizedBox(
                    width: 10,
                  ),
                  _getChannelButton(settings.baseUrl, settings.zoneList[index], Icons.skip_previous),
                  SizedBox(
                    width: 10,
                  ),
                  _getChannelButton(settings.baseUrl, settings.zoneList[index], Icons.skip_next),
                  //IconButton(icon: Icon(Icons.volume_up), color: Colors.blue[800], onPressed: () {},),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    });
  }
}
