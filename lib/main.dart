import 'dart:developer';

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
  PermissionProvider permissionProvider = PermissionProvider();
  @override
  void initState() {
    checkPermission();
    super.initState();
  }

  void checkPermission() async {
    if (permissionProvider.isPermit == false) {
      await permissionProvider.promptPermissionSetting();
    }
  }

  @override
  Widget build(BuildContext context) {
    log('main');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AudioProvider(
            advancedPlayer: AudioPlayer(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => permissionProvider,
        )
      ],
      builder: (context, child) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Music Player',
          home: AudioList(),
        );
      },
    );
  }
}
