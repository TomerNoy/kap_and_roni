import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kap_and_roni/storage/pref.dart';
import 'app/app.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final difficulty = await Pref().getDifficulty();
  runApp(
    ProviderScope(
      child:
          MaterialApp(theme: buildTheme(), home: App(difficulty: difficulty)),
    ),
  );
}
