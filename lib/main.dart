import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:podeo_calculator/view/auth/login.dart';
import 'package:podeo_calculator/view/home/home_screen.dart';
import 'constants/colors.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'models/calculation.dart';

late Box box1;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Directory directory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  box1 = await Hive.openBox('loginData');
  Hive.registerAdapter(CalculationAdapter());
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Podeo Calculator',
      debugShowCheckedModeBanner: false,
      theme: MyThemes.darkThemeData,
      home: box1.get('isLogged') != null ? HomeScreen(email: box1.get('isLogged'),) : LoginScreen(),
    );
  }
}

