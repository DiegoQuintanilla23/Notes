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
                        paintingStyle: PaintingStyle.stroke,
                        strokeWidth: 8,
                        shape: BubbleShape.circle,
                        speed: BubbleSpeed.normal,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Cambiar tema',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Switch(
                          value: sgl.isDarkMode,
                          activeColor: cons.blanco,
                          activeTrackColor: cons.negro,
                          inactiveThumbColor: Colors.yellow,
                          inactiveTrackColor: Colors.lightBlue,
                          onChanged: (bool value) {
                            setState(() {
                              sgl.isDarkMode = value;
                              activated = sgl.isDarkMode;
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
