import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/navigation_bar.dart';
import 'providers/my_app_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'HearBat',
        theme: ThemeData(
          useMaterial3: true,
          textTheme: GoogleFonts.beVietnamProTextTheme(
            Theme.of(context).textTheme,
          ),
          colorScheme:
              ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 67, 0, 99)),
        ),
        home: MyNavBar(),
      ),
    );
  }
}
