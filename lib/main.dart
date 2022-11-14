import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music/provider.dart';
import 'package:provider/provider.dart';

import 'audiolist.dart';
import 'permissio.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    checkPermission();
    super.initState();
  }

  void checkPermission() async {
    final status = PermissionSettings.isPermit;
    if (status == false) {
      await PermissionSettings.promptPermissionSetting();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AudioProvider(
            advancedPlayer: AudioPlayer(),
          ),
        ),
      ],
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Music Player',
          home: AudioList(),
        );
      },
    );
  }
}
