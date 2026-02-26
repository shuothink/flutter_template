import 'package:flutter/material.dart';
import 'package:flutter_template/app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };

  runApp(const MyApp());
}
