import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wha_flutter/zones.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsError extends Error {
  final String message;

  SettingsError(this.message);
}

class SettingsNotifier with ChangeNotifier {
  static const BASE_URL = "baseURL";
  static const ZONE = "zones";

  SettingsState _currentSettings = SettingsState("http://home-pi.local:8182", "{ \"1\" : \" Zone 1\"}");

  SettingsNotifier() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    print("shared setting " + sharedPrefs.get(BASE_URL));
    var baseUrl =
        sharedPrefs.getString(BASE_URL ?? "http://home-pi.local:8183");
    var zones = sharedPrefs.getString(ZONE ?? "{ \"2\" : \" Zone 2\"}");
    _currentSettings = SettingsState(baseUrl, zones);
    notifyListeners();
  }

  Future<void> _saveNewURLSettings() async {
    _saveNewSettings(BASE_URL, _currentSettings.baseUrl);
  }

  Future<void> _saveZoneSettings() async {
    _saveNewSettings(ZONE, _currentSettings.zones);
  }

  Future<void> _saveNewSettings(String pref, String value) async {
    var sharedPrefs = await SharedPreferences.getInstance();
    print("saving setting: pref $pref value $value");
    await sharedPrefs.setString(pref, value);
  }

  // Future<void> _saveAllSettings() async {
  //   var sharedPrefs = await SharedPreferences.getInstance();
  //   print("saving setting"+ _currentSettings.baseUrl);
  //   await sharedPrefs.setString(BASE_URL, _currentSettings.baseUrl);
  //   await sharedPrefs.setString(ZONE, _currentSettings.zones);
  // }

  String get baseUrl => _currentSettings.baseUrl;

  set baseUrl(String newBaseUrl) {
    if (newBaseUrl == _currentSettings.baseUrl) return;

    print("is this called $newBaseUrl" );
    _currentSettings = SettingsState(newBaseUrl, _currentSettings.zones);
    notifyListeners();
    _saveNewURLSettings();
  }

  String get zones => _currentSettings.zones;

  Map<String, dynamic> getZoneMap() {
    return json.decode(_currentSettings.zones);
  }

  set zones(String newZones) {
    if(newZones == _currentSettings.zones) return;
  
    print("is this called $zones");
    _currentSettings = SettingsState(_currentSettings.baseUrl, newZones);
    notifyListeners();
    _saveZoneSettings();
  }
}

class SettingsState {
  final String baseUrl;
  final String zones;

  const SettingsState(this.baseUrl, this.zones);
}

class Settings {
  String url;
  List<Zone> zones = new List<Zone>();

  Settings();

  String getZoneLabelMap() {
    Map zoneLabelMap = HashMap<String, String>();

    for(Zone zone in zones) {
      zoneLabelMap.putIfAbsent(zone.zone, () => zone.label);
    }

    return json.encode(zoneLabelMap);
  }
  
}
