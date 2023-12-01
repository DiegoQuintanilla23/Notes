import 'dart:async';
import 'package:app_notes/home.dart';
import 'package:app_notes/login.dart';
import 'package:app_notes/utils/singleton.dart';
import 'package:flutter/material.dart';
import 'package:app_notes/utils/cons.dart' as cons;
import 'package:floating_bubbles/floating_bubbles.dart';
import 'services/firebase_service.dart';

class Singin extends StatefulWidget {
  const Singin({super.key});

  @override
  State<Singin> createState() => _SinginState();
}

class _SinginState extends State<Singin> {
  //int _selectedIndex = 0;
  final user = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool _validateEmail = false;
  bool _validatePass = false;
  bool _validateUser = false;
  late ThemeData currentTheme;
  Singleton sgl = Singleton();

  @override
  void initstate() {
    //currentTheme = sgl.isDarkMode ? cons.darkTheme : cons.lightTheme;
    currentTheme = cons.lightTheme;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Theme(
      data: cons.lightTheme,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: FloatingBubbles(
                noOfBubbles: 30,
                colorsOfBubbles: [
                  Colors.cyan,
                  Color.fromARGB(255, 151, 235, 247),
                ],
                sizeFactor: 0.16,
                duration: 3000, // 120 seconds.
                opacity: 70,
                paintingStyle: PaintingStyle.stroke,
                strokeWidth: 8,
                shape: BubbleShape.circle,
                speed: BubbleSpeed.normal,
              ),
            ),
            Container(
              padding: EdgeInsets.all(60),
              alignment: Alignment.center,
              child: Card(
                color: Color.fromARGB(98, 27, 26, 26),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'REGISTRARSE',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const titulo(
                        texto: 'Nombre:',
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: TextFormField(
                          controller: user,
                          obscureText: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    width: 1, style: BorderStyle.none)),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Color.fromARGB(255, 57, 57, 57),
                              size: 20,
                            ),
                            hintText: 'Nombre',
                            errorText: _validateUser
                                ? 'Debe escribir el nombre'
                                : null,
                            filled: true,
                            fillColor: const Color.fromARGB(255, 158, 158, 158),
                            hintStyle: TextStyle(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                            labelStyle: TextStyle(color: Colors.teal),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                          onChanged: (dato) {
                            setState(() {
                              if (dato.trim().isNotEmpty) {
                                _validateUser = false;
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const titulo(
                        texto: 'Correo:',
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: TextFormField(
                          controller: email,
                          obscureText: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    width: 1, style: BorderStyle.none)),
                            prefixIcon: Icon(
                              Icons.mail,
                              color: Color.fromARGB(255, 57, 57, 57),
                              size: 20,
                            ),
                            hintText: 'Correo',
                            errorText: _validateEmail
                                ? 'Debe escribir el Correo'
                                : null,
                            filled: true,
                            fillColor: const Color.fromARGB(255, 158, 158, 158),
                            hintStyle: TextStyle(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                            labelStyle: TextStyle(color: Colors.teal),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                          onChanged: (dato) {
                            setState(() {
                              if (dato.trim().isNotEmpty) {
                                _validateEmail = false;
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      const titulo(
                        texto: 'Contraseña:',
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: TextFormField(
                          controller: pass,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    width: 1, style: BorderStyle.none)),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: const Color.fromARGB(255, 57, 57, 57),
                              size: 20,
                            ),
                            hintText: 'Contraseña',
                            errorText: _validatePass
                                ? 'Debe escribir la contraseña'
                                : null,
                            filled: true,
                            fillColor: const Color.fromARGB(255, 158, 158, 158),
                            hintStyle: TextStyle(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                            contentPadding: const EdgeInsets.all(10),
                          ),
                          onChanged: (dato) {
                            setState(() {
                              if (dato.trim().isNotEmpty) {
                                _validatePass = false;
                              }
                            });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      GestureDetector(
                        onTap: () async {
                          user.text.isEmpty
                              ? _validateUser = true
                              : _validateUser = false;
                          email.text.isEmpty
                              ? _validateEmail = true
                              : _validateEmail = false;
                          pass.text.isEmpty
                              ? _validatePass = true
                              : _validatePass = false;

                          if (!_validateEmail &&
                              !_validatePass &&
                              !_validateUser) {
                            //sgl.usuario = user.text;
                            //sgl.contrasenia = pass.text;
                            await addUser(user.text, email.text, pass.text);
                            _showSnackbar(context);
                          }
                        },
                        child: Container(
                          width: size.width * 0.55,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(159, 62, 255, 220),
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage('assets/bkgrndsq.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Registrarse',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                          child: Text(
                            'Iniciar Sesion',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class titulo extends StatelessWidget {
  final String texto;
  const titulo({super.key, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 50, right: 50),
          child: Text(
            texto,
            style: const TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
          ),
        )
      ],
    );
  }
}

void _showSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Usuario Registrado'),
      backgroundColor: Color.fromARGB(255, 57, 57, 57),
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.fixed,
    ),
  );
  // Espera 3 segundos antes de navegar a otra pantalla
  Timer(Duration(seconds: 3), () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  });
}
