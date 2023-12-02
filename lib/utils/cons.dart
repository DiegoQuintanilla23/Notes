import 'package:flutter/material.dart';

const azul = Color.fromRGBO(150, 235, 234, 0.906);
const azulF = Color.fromRGBO(41, 214, 212, 0.906);
const gris = Color.fromARGB(255, 192, 192, 192);
const negro = Color.fromARGB(255, 0, 0, 0);
const blanco = Color.fromARGB(255, 255, 255, 255);
const naranja = Color(0xFFF79D6A);
const contligth = Color.fromARGB(248, 232, 232, 232);
const contdark = Color.fromARGB(248, 105, 105, 105);
const bub1light = Colors.cyan;
const bub2light = Color.fromARGB(255, 151, 235, 247);
const bub1dark = Color.fromARGB(255, 189, 189, 189);
const bub2dark = Color.fromARGB(255, 255, 255, 255);
const controllerfill = Color.fromRGBO(236, 236, 236, 0.694);
const cardfill = Color.fromARGB(177, 57, 57, 57);

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: naranja,
  buttonTheme:
      ButtonThemeData(buttonColor: naranja // Color de botón en el modo claro
          ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.indigo,
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.indigo, // Color de botón en el modo oscuro
  ),
);
