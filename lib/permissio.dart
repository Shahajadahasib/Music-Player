import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionSettings with ChangeNotifier {
  // request storage permission
  static bool isPermit = false;

  static Future<bool> promptPermissionSetting() async {
    if (await Permission.storage.request().isGranted) {
      isPermit = true;
      ChangeNotifier();
      return true;
    } else {
      isPermit = false;
      ChangeNotifier();
      return false;
    }
  }
}
