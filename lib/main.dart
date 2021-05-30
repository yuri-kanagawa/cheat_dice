import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zflutter/zflutter.dart';
import 'dice1.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


import 'mobad.dart';
import 'screen_change.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AdmobService.initialize();
  runApp(new MaterialApp(home: new ScreenList()));
}