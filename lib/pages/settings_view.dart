import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wha_flutter/model/settings_model.dart';

class SettingsReadOnly extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Consumer<SettingsNotifier>(
          builder: (_, settings, __) => ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: settings.getZoneMap() == null ? 1 : settings.getZoneMap().length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    leading: Icon(Icons.link, color: Colors.red[300]),
                    title: Text(settings.baseUrl?? "Url Not Set"),
                  );
                } else {
                  String key = settings.getZoneMap().keys.elementAt(index - 1);
                  return ListTile(
                    leading: Icon(
                      Icons.speaker_group,
                      color: Colors.brown[400],
                    ),
                    title: Text(settings.getZoneMap()[key]?? key),
                    subtitle: Text("Zone " + key),
                  );
                }
              })),
    );
  }
}
