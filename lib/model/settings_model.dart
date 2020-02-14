import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wha_flutter/model/zones.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsError extends Error {
  final String message;

  SettingsError(this.message);
}

class SettingsNotifier with ChangeNotifier {
  static const BASE_URL = "baseURL";
  static const ZONE = "zones";

  SettingsState _currentSettings = SettingsState("nada", null, null);

  SettingsNotifier() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    print("settings_model.dart shared setting ${sharedPrefs.get(BASE_URL)}");
    var baseUrl = sharedPrefs.getString(BASE_URL);
    var zones = sharedPrefs.getString(ZONE);
    List<Zone> zoneList;

    if(baseUrl != null) {
      ZoneAPI.getZones(baseUrl).then((response) {
        refreshZones();
      });
    }
    _currentSettings = SettingsState(baseUrl, zones, zoneList);
    notifyListeners();
  }

  Future<void> _saveNewURLSettings() async {
    _saveNewSettings(BASE_URL, _currentSettings.baseUrl);
  }

  Future<void> _saveZoneSettings() async {
    _saveNewSettings(ZONE, _currentSettings.zones);
    refreshZones();
  }

  Future<void> _saveNewSettings(String pref, String value) async {
    var sharedPrefs = await SharedPreferences.getInstance();
    print(
        "settings_model.dart._saveNewSettings saving setting: pref $pref value $value");
    await sharedPrefs.setString(pref, value);
  }

  Future<void> refreshZones() async {
    List<Zone> zoneList;
    ZoneAPI.getZones(baseUrl).then((response) {
      Iterable list = json.decode(response.body);
      zoneList = list.map((model) => Zone.fromJson(model)).toList();

      if (zoneList == null) {
        zoneList = [];
      }

      _currentSettings = SettingsState(baseUrl, zones, zoneList);
      notifyListeners();
    });
  }

  String get baseUrl => _currentSettings.baseUrl;

  set baseUrl(String newBaseUrl) {
    if (newBaseUrl == _currentSettings.baseUrl) return;

    _currentSettings = SettingsState(
        newBaseUrl, _currentSettings.zones, _currentSettings.zoneList);
    notifyListeners();
    _saveNewURLSettings();
  }

  List<Zone> get zoneList => _currentSettings.zoneList;

  String get zones => _currentSettings.zones;

  Map<String, dynamic> getZoneMap() {
    if (_currentSettings.zones == null) {
      return null;
    }
    return json.decode(_currentSettings.zones);
  }

  String getZoneLabel(int index) {
    List<Zone> zoneList = _currentSettings.zoneList;

    //Does zone exist
    if (_currentSettings.zones == null ||
        zoneList == null ||
        index >= zoneList.length ||
        zoneList.elementAt(index) == null) {
      return null;
    }
    Zone zone = _currentSettings.zoneList.elementAt(index);

    return getZoneMap()[zone.zone];
  }

  set zones(String newZones) {
    if (newZones == _currentSettings.zones) return;

    _currentSettings = SettingsState(
        _currentSettings.baseUrl, newZones, _currentSettings.zoneList);
    notifyListeners();
    _saveZoneSettings();
  }
}

class SettingsState {
  final String baseUrl;
  final String zones;
  final List<Zone> zoneList;

  const SettingsState(this.baseUrl, this.zones, this.zoneList);
}

class Settings {
  String url;
  List<Zone> zones = new List<Zone>();

  Settings();

  String getZoneLabelMap() {
    Map zoneLabelMap = HashMap<String, String>();

    for (Zone zone in zones) {
      zoneLabelMap.putIfAbsent(zone.zone, () => zone.label);
    }

    return json.encode(zoneLabelMap);
  }
}
