import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:music/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class PermissionProvider with ChangeNotifier {
  // request storage permission

  bool _isPermit = false;

  bool get isPermit => _isPermit;

  // set isPermit(bool value) {
  //   _isPermit = value;
  //   notifyListeners();
  // }

  Future<bool> promptPermissionSetting() async {
    if (await Permission.storage.request().isGranted) {
      _isPermit = true;
      log(_isPermit.toString());
      notifyListeners();
      return true;
    } else {
      _isPermit = false;
      log(_isPermit.toString());
      notifyListeners();
      return false;
    }
  }
}
