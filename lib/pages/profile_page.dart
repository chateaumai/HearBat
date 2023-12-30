import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  String? _voicePreference;

  @override
  void initState() {
    super.initState();
    _loadVoicePreference();
  }

  _loadVoicePreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _voicePreference = prefs.getString('voicePreference') ?? "en-US-Studio-O";
    });
  }

  _updateVoicePreference(String voiceType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _voicePreference = voiceType;
      prefs.setString('voicePreference', voiceType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Select Voice Type",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge),
          ),
          ListTile(
            title: const Text('Female'),
            leading: Radio<String>(
              value: "en-US-Studio-O",
              groupValue: _voicePreference,
              onChanged: _voicePreference == null
                  ? null
                  : (String? value) {
                      _updateVoicePreference(value!);
                    },
            ),
          ),
          ListTile(
            title: const Text('Male'),
            leading: Radio<String>(
              value: "en-US-Studio-Q",
              groupValue: _voicePreference,
              onChanged: _voicePreference == null
                  ? null
                  : (String? value) {
                      _updateVoicePreference(value!);
                    },
            ),
          ),
        ],
      ),
    );
  }
}
