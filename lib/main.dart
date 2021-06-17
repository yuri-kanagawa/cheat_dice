import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'mobad.dart';
import 'screen_change.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AdmobService.initialize();
  runApp(
    new MaterialApp(
      home: new ScreenList(),
    ),
  );
}
