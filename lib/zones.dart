import 'package:http/http.dart' as http;
import 'dart:async';

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
  final String power; //pr

  Zone({this.zone, this.mute, this.volume, this.channel, this.power});
  
  Zone.fromJson(Map json) 
    : zone = json['zone'],
      mute = json['mu'],
      volume = json['vo'],
      channel = json['ch'],
      power = json['pr'];
  
  Map toJson() {
    return { 'zone': zone, 'mute': mute, 'volume': volume, 'channel': channel, 'power': power};
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