import 'package:flutter/material.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      home: AudioList(),
    );
  }
}
