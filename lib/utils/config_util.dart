import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hearbat/firebase_options.dart';

class ConfigurationManager {
  static final ConfigurationManager _instance =
      ConfigurationManager._internal();
  late final String googleCloudAPIKey;

  // Singleton pattern to ensure only one instance of ConfigurationManager exists.
  factory ConfigurationManager() {
    return _instance;
  }

  ConfigurationManager._internal();

  // Initializes Firebase and fetches remote configuration values.
  Future<void> fetchConfiguration() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    googleCloudAPIKey = remoteConfig.getString('googleCloud');
  }
}
