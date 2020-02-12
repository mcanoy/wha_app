import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wha_flutter/model/settings_model.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Retrieve Text Input',
      home: MyCustomForm(),
    );
  }
}

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<SettingsNotifier>(
            builder: (_, settings, __) => Text(settings.baseUrl)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Consumer<SettingsNotifier>(
            builder: (_, settings, __) => ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                itemCount: settings.getZoneMap().length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return ListTile(
                      leading: Icon(Icons.link, color: Colors.red[300]),
                      title: Text(settings.baseUrl),
                    );
                  } else {
                    String key =
                        settings.getZoneMap().keys.elementAt(index - 1);
                    return ListTile(
                      leading: Icon(
                        Icons.speaker_group,
                        color: Colors.brown[400],
                      ),
                      title: Text(settings.getZoneMap()[key]),
                      subtitle: Text("Zone " + key),
                    );
                  }
                })),
      ),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          //settingsNotifier.baseUrl = myController.text;
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Retrieve the text the that user has entered by using the
                // TextEditingController.
                content: Text(myController.text),
              );
            },
          );
        },
        tooltip: 'Show me the value!',
        child: Icon(Icons.text_fields),
      ),
    );
  }
}
