import 'package:app_notes/navbar.dart';
import 'package:app_notes/services/firebase_service.dart';
import 'package:app_notes/taskedit.dart';
import 'package:app_notes/utils/singleton.dart';
import 'package:flutter/material.dart';
import 'package:app_notes/utils/cons.dart' as cons;
import 'package:floating_bubbles/floating_bubbles.dart';

Singleton sgl = Singleton();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //int _selectedIndex = 0;
  late ThemeData currentTheme;

  @override
  Future<void> initstate() async {
    //currentTheme = sgl.isDarkMode ? cons.darkTheme : cons.lightTheme;
    getData();
    currentTheme = cons.lightTheme;
    super.initState();
  }

  void getData() async {
    Map<String, String>? userData = await getUserDataById(sgl.docIDuser);
    if (userData != null) {
      sgl.usuario = userData['nombre']!;
      sgl.correo = userData['email']!;
    }
  }

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
          title: Row(
            children: [
              Text('|', style: TextStyle(fontSize: 24, color: cons.negro)),
              SizedBox(width: 50),
              Text(
                'Notes',
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
        drawer: NavBar(
          usuario: sgl.usuario,
          correo: sgl.correo,
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
                        duration: 4000, // 120 seconds.
                        opacity: 70,
                        paintingStyle: PaintingStyle.stroke,
                        strokeWidth: 8,
                        shape: BubbleShape.circle,
                        speed: BubbleSpeed.normal,
                      ),
                    ),
                    FutureBuilder(
                      future: getTasksByUserId(sgl.docIDuser),
                      builder: ((context,
                          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              var document = snapshot.data?[index];
                              return InkWell(
                                onTap: () async {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TaskEdit(
                                              TaskID: document?['documentId'],
                                            )),
                                  );
                                },
                                child: Text(
                                  document?['title'],
                                ),
                              );
                            },
                          );
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TaskEdit(
                  TaskID: '-1',
                ),
              ),
            );
          },
          child: Icon(Icons.post_add),
          backgroundColor: Color.fromARGB(132, 71, 199, 225),
        ),
      ),
    );
  }
}
