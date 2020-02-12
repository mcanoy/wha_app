import 'package:http/http.dart' as http;
import 'dart:async';

//const baseURL = "http://localhost:8080/zones.json";
const baseURL = "http://home-pi.local:8181/zones";

class ZoneAPI {
  static Future getZone() async {
    var url = baseURL + "/11";
    return http.get(url);
  }

  static Future<http.Response> getZones(String url) async {
    print("zones.dart Base Url: $url");
    return await http.get("$url/zones");
  }

  static Future<http.Response> changeZone(String baseUrl, String zone, String setting, String adjustment) async {
    var url = "$baseURL/$zone/$setting/";
    print("Chage zone $url"); 
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