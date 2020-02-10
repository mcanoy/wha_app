import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

//const baseURL = "http://localhost:8080/zones.json";
const baseURL = "http://home-pi.local:8181/zones";

class ZoneAPI {
  static Future getZone() async {
    var url = baseURL + "/11";
    return http.get(url);
  }

  static Future<http.Response> getZones() async {
    var url = baseURL;
    return await http.get(url);
  }

  // static List<Zone> getZonesWithLabels() {
  //   var url = baseURL;
  //   final sharedPrefs = await SharedPreferences.getInstance();
  //   var zones= List<Zone>();
  //   // await http.get(url).then((response) {
  //   //   String zoneLabelString = sharedPrefs.getString("ZONES");
  //   //   Map<String, String> zoneLabelMap = json.decode(zoneLabelString);

  //   //   Iterable list = json.decode(response.body);
  //   //   zones = list.map((model) { 
  //   //     Zone zone = Zone.fromJson(model);
  //   //     zone.label = zoneLabelMap[zone.zone];
  //   //   }).toList();
  //   // });
  //   return zones;// (response) => print('hi'));
  // }

  static Future<http.Response> changeZone(String zone, String setting, String adjustment) async {
    var url = "$baseURL/$zone/$setting/";
    return await http.post(url, body: adjustment);
  }

}

class Zone {

  final String zone; //zone
  final String mute; //mu
  final String volume; //vo
  final String channel; //ch
  final String power; 
  String label;//pr

  Zone({this.zone, this.mute, this.volume, this.channel, this.power, this.label});
  
  Zone.fromJson(Map json) 
    : zone = json['zone'],
      mute = json['mu'],
      volume = json['vo'],
      channel = json['ch'],
      power = json['pr'],
      label = json['label'];
  
  Map toJson() {
    return { 'zone': zone, 'mute': mute, 'volume': volume, 'channel': channel, 'power': power, 'label': label};
  }

  String powerAdjust(int adjust) {
    return (int.parse(volume)+adjust).toString();
  }

  String channelAdjust(int adjust) {
    var newChannel = int.parse(channel)+adjust;
    if(newChannel == 0) {
      newChannel = 6;
    } else if(newChannel == 7) {
      newChannel = 1;
    }

    print("ch " + newChannel.toString().padLeft(2, '0'));
    return newChannel.toString().padLeft(2, '0');
  }
  
}