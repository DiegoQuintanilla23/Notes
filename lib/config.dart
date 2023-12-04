import 'package:app_notes/home.dart';
import 'package:app_notes/utils/singleton.dart';
import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:app_notes/utils/cons.dart' as cons;

class Config extends StatefulWidget {
  const Config({super.key});
  @override
  State<Config> createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  bool activated = false;
  Singleton sgl = Singleton();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    ThemeData currentTheme = sgl.isDarkMode ? cons.darkTheme : cons.lightTheme;
    return Theme(
      data: currentTheme, // Establece el tema actual aquí
      child: Scaffold(
        appBar: AppBar(
          elevation: 10.0,
          flexibleSpace: Image.asset(
            'assets/bkgrndsq.png',
            fit: BoxFit.fill,
          ),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Home()));
            },
            color: cons.negro,
          ),
          title: Row(
            children: [
              Text('|', style: TextStyle(fontSize: 24, color: cons.negro)),
              SizedBox(width: 50),
              Text(
                'Configuración',
                style: TextStyle(
                  color: cons.negro,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ],
          ),
          iconTheme: IconThemeData(color: cons.negro),
        ),
        body: Stack(
          children: [
            Center(
              child: Card(
                elevation: 15.0,
                margin: EdgeInsets.all(13.0),
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: size.height - kToolbarHeight - 16.0,
                      color: sgl.isDarkMode ? cons.contdark : cons.contligth,
                    ),
                    Positioned.fill(
                      child: FloatingBubbles(
                        noOfBubbles: 30,
                        colorsOfBubbles: [
                          sgl.isDarkMode ? cons.bub1dark : cons.bub1light,
                          sgl.isDarkMode ? cons.bub2dark : cons.bub2light,
                        ],
                        sizeFactor: 0.16,
                        duration: 3000, // 120 seconds.
                        opacity: 70,
                        paintingStyle: sgl.isStroke
                            ? PaintingStyle.stroke
                            : PaintingStyle.fill,
                        strokeWidth: 8,
                        shape: sgl.isSquare
                            ? BubbleShape.square
                            : BubbleShape.circle,
                        speed: BubbleSpeed.normal,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildSwitchRow(
                          label: 'Orden de Notas\nFecha/Titulo',
                          value: sgl.order,
                          onChanged: (bool value) {
                            sgl.order = value;
                            setState(() {
                              sgl.order = value;
                            });
                          },
                        ),
                        buildSwitchRow(
                          label: 'Cambiar tema',
                          value: sgl.isDarkMode,
                          onChanged: (bool value) {
                            sgl.isDarkMode = value;
                            setState(() {
                              sgl.isDarkMode = value;
                            });
                          },
                        ),
                        buildSwitchRow(
                          label: 'Fondo de Cuadros',
                          value: sgl.isSquare,
                          onChanged: (bool value) {
                            sgl.isSquare = value;
                            setState(() {
                              sgl.isSquare = value;
                            });
                          },
                        ),
                        buildSwitchRow(
                          label: 'Relleno del Fondo',
                          value: sgl.isStroke,
                          onChanged: (bool value) {
                            sgl.isStroke = value;
                            setState(() {
                              sgl.isStroke = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildSwitchRow({
  required String label,
  required bool value,
  required ValueChanged<bool> onChanged,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      Switch(
        value: value,
        activeColor: cons.blanco,
        activeTrackColor: cons.negro,
        inactiveThumbColor: value ? Colors.yellow : cons.negro,
        inactiveTrackColor: value ? Colors.lightBlue : cons.blanco,
        onChanged: onChanged,
      ),
    ],
  );
}
