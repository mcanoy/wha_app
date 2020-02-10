import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wha_flutter/model/settings_model.dart';
import 'package:wha_flutter/zones.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:validators/validators.dart';

class SettingsWidget extends StatefulWidget {
  @override
  _SettingsWidgetState createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  final _form = GlobalKey<FormState>();

  int currentStep = 0;
  int totalSteps = 2;
  bool complete = false;
  bool validUrl = true;
  SettingsState settingsState;
  String zoneLabels;

  final serverUrlController = TextEditingController(text: "FIRST");
  var zoneControllerMap = Map<String, TextEditingController>();

  Settings settings = Settings();

  next() {
    if (currentStep == 0) {
      stepOne();
    } else if (currentStep == 1) {
      stepTwo();
    }
  }

  stepOne() {
    bool success = false;
    setState(() {
      validUrl = true;
    });

    settings.url = serverUrlController.text;
    print("server url = " + settings.url);

    if (isURL(settings.url, protocols: ["http", "https"])) {
      http.get(settings.url + "/zones").then((response) {
        print(response.statusCode);
        List<Zone> zones = [];
        try {
          Iterable list = json.decode(response.body);

          zones = list.map((model) => Zone.fromJson(model)).toList();
          settings.zones = zones;
          validUrl = true;
          success = true;
          serverUrlController.text = '';
          final settingsNotifier =
              Provider.of<SettingsNotifier>(context, listen: false);
          print(" zones " + settingsNotifier.zones);
        } catch (e) {
          print('caught');
          settings.zones = [];
        }
        setState(() {
          print("zones " + zones.length.toString());
          settings.zones = zones;
          validUrl = success;
          if (success) currentStep = 1;
        });
      }).catchError((e) {
        setState(() {
      validUrl = success;
    });
      });
    } else {
      print("validator => this not a url");
      setState(() {
      validUrl = success;
    });
    }
  }

  stepTwo() {
    final zonePrefMap = HashMap<String, String>();

    zoneControllerMap.forEach(
        (zone, value) => zonePrefMap.putIfAbsent(zone, () => value.text));

    setState(() {
      zoneLabels = zonePrefMap.toString();
      _form.currentState.save();
      final settingsNotifier =
          Provider.of<SettingsNotifier>(context, listen: false);
      settingsNotifier.baseUrl = settings.url;
      settingsNotifier.zones = settings.getZoneLabelMap();
      complete = true;
    });
  }

  goTo(int step) {
    print("go to " + step.toString());
    setState(() => currentStep = step);
    if (currentStep == 0) {
      serverUrlController.text = settings.url;
    }
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  FloatingActionButton _editButton() {
    return !complete ? null : FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () {
          setState(() {
            complete = false;
            currentStep = 0;
          });
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    final settingsNotifier = Provider.of<SettingsNotifier>(context);
    final zoneLabelMap = settingsNotifier.getZoneMap();
    if (serverUrlController.text == "FIRST") {
      serverUrlController.text = settingsNotifier.baseUrl;
    } else if(settings.url.isNotEmpty) {
      serverUrlController.text = settings.url;
    }

    return new Scaffold(
      appBar: AppBar(
        title: Text('Zone Settings'),
      ),
      floatingActionButton: _editButton(),
      body: complete
          ? ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: settings.zones.length + 1,
              itemBuilder: (context, index) {
                if(index == 0) {
                  return ListTile(
                    leading: Icon(Icons.link, color: Colors.red[300]),
                    title: Text(settings.url),
                  );
                } else {
                  return ListTile(
                    leading: Icon(Icons.speaker, color: Colors.brown[400],),
                    title: Text(zoneLabelMap[settings.zones[index-1].zone]),
                    subtitle: Text("Zone " + settings.zones[index-1].zone),);
                }
              })
          : Column(
              children: <Widget>[
                Expanded(
                  child: Stepper(
                    type: StepperType.vertical,
                    steps: [
                      Step(
                        title: const Text('Server Url'),
                        subtitle:
                            (settings.url != null) ? Text(settings.url) : null,
                        isActive: currentStep == 0,
                        state: StepState.complete,
                        content: Column(
                          children: <Widget>[
                            TextFormField(
                              autocorrect: false,
                              controller: serverUrlController,
                              decoration: InputDecoration(
                                  errorText: validUrl
                                      ? null
                                      : 'Invalid URL / No zones found',
                                  labelText: "Update URL"),
                            ),
                          ],
                        ),
                      ),
                      Step(
                        isActive: currentStep == 1,
                        state: StepState.editing,
                        title: const Text('Zone Labels'),
                        content: Form(
                          key: _form,
                          child: Column(
                            children: <Widget>[
                              for (Zone zone in settings.zones)
                                TextFormField(
                                    initialValue: zoneLabelMap[zone.zone],
                                    decoration:
                                        InputDecoration(labelText: zone.zone),
                                    onSaved: (String value) {
                                      if (value.isNotEmpty) {
                                        zone.label = value;
                                      }
                                    }),
                            ],
                          ),
                        ),
                      ),
                    ],
                    currentStep: currentStep,
                    onStepContinue: next,
                    onStepTapped: (step) => goTo(step),
                    onStepCancel: cancel,
                  ),
                ),
              ],
            ),
    );
  }
}
