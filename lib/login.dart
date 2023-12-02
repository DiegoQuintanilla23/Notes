import 'package:app_notes/home.dart';
import 'package:app_notes/services/firebase_service.dart';
import 'package:app_notes/singin.dart';
import 'package:app_notes/utils/singleton.dart';
import 'package:flutter/material.dart';
import 'package:app_notes/utils/cons.dart' as cons;
import 'package:floating_bubbles/floating_bubbles.dart';

//////////////////////////////
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //int _selectedIndex = 0;
  final email = TextEditingController();
  TextEditingController pass = TextEditingController();
  bool _validateEmail = false;
  bool _validatePass = false;
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
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned.fill(
                child: FloatingBubbles(
                  noOfBubbles: 30,
                  colorsOfBubbles: const [
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
                padding: EdgeInsets.all(30),
                alignment: Alignment.center,
                child: Card(
                  color: const Color.fromARGB(98, 27, 26, 26),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'INGRESAR',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const titulo(
                          texto: 'Correo:',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            controller: email,
                            obscureText: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      width: 1, style: BorderStyle.none)),
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Color.fromARGB(255, 57, 57, 57),
                                size: 20,
                              ),
                              hintText: 'Correo',
                              errorText: _validateEmail
                                  ? 'Debe escribir el Correo'
                                  : null,
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 158, 158, 158),
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
                              labelStyle: const TextStyle(color: Colors.teal),
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
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            controller: pass,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      width: 1, style: BorderStyle.none)),
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Color.fromARGB(255, 57, 57, 57),
                                size: 20,
                              ),
                              hintText: 'Contraseña',
                              errorText: _validatePass
                                  ? 'Debe escribir la contraseña'
                                  : null,
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 158, 158, 158),
                              hintStyle: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)),
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
                            email.text.isEmpty
                                ? _validateEmail = true
                                : _validateEmail = false;
                            pass.text.isEmpty
                                ? _validatePass = true
                                : _validatePass = false;

                            if (!_validateEmail && !_validatePass) {
                              sgl.docIDuser =
                                  (await getUserIdByEmailAndPassword(
                                      email.text, pass.text))!;
                              print(sgl.docIDuser);
                              if (sgl.docIDuser != '') {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home()),
                                );
                              } else {
                                _showSnackbar(context);
                              }
                            } else {
                              _showSnackbar(context);
                            }
                          },
                          child: Container(
                            width: size.width * 0.55,
                            height: 45,
                            decoration: BoxDecoration(
                              color: cons.azulF,
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(
                                image: AssetImage('assets/bkgrndsq.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Ingresar',
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
                                      builder: (context) => Singin()));
                            },
                            child: const Text(
                              'Registrate',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
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
          padding: const EdgeInsets.only(left: 50, right: 50),
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
    const SnackBar(
      content: Text('Usuario No Encontrado'),
      backgroundColor: Color.fromARGB(255, 57, 57, 57),
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.fixed,
    ),
  );
}
