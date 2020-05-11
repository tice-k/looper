import 'package:flutter/material.dart';
import 'package:looper/navigation.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MaterialApp(
    navigatorKey: navigatorKey,
    home: Navigation(),
  ));
}
