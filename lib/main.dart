import 'package:app_notes/firebase_options.dart';
import 'package:app_notes/home.dart';
import 'package:app_notes/login.dart';
import 'package:app_notes/viewmap.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 131, 195, 255)),
        useMaterial3: true,
      ),
      home: const Login(),
      //home: const Home(),
      //home: ViewTask(title: 'Título de la tarea',content: 'Contenido de la tarea',),
      //home: ViewMap(latitude: 22.143214, longitude: -101.015666),
    );
  }
}
