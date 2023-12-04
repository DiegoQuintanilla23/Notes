/*
import 'dart:async';

import 'package:app_notes/navbar.dart';
import 'package:app_notes/services/firebase_service.dart';
import 'package:app_notes/taskedit.dart';
import 'package:app_notes/utils/singleton.dart';
import 'package:app_notes/viewtask.dart';
import 'package:flutter/material.dart';
import 'package:app_notes/utils/cons.dart' as cons;
import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:intl/intl.dart';

Singleton sgl = Singleton();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ThemeData currentTheme;
  String orderByField = 'date'; // Campo inicial de ordenamiento
  late Future<List<Map<String, dynamic>>> tasksFuture;

  @override
  void initState() {
    super.initState();
    getData();
    currentTheme = cons.lightTheme;
    tasksFuture = getTasksByUserIdWithOrder(sgl.docIDuser, "title");
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
      data: currentTheme,
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
                        duration: 4000,
                        opacity: 70,
                        paintingStyle: PaintingStyle.stroke,
                        strokeWidth: 8,
                        shape: BubbleShape.circle,
                        speed: BubbleSpeed.normal,
                      ),
                    ),
                    FutureBuilder(
                      future: getTasksByUserIdWithOrder(
                          sgl.docIDuser, orderByField),
                      builder: (context,
                          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          if (snapshot.data != null &&
                              snapshot.data!.isNotEmpty) {
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                var document = snapshot.data![index];
                                return Card(
                                  color: Colors.transparent,
                                  margin: EdgeInsets.all(6.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: cons.cardfill,
                                    ),
                                    child: ListTile(
                                      leading: Container(
                                        alignment: Alignment.center,
                                        width: 40.0,
                                        child: Icon(
                                          Icons.list,
                                          color: cons.gris,
                                        ),
                                      ),
                                      title: Text(
                                        document?['title'] ?? '',
                                        style: TextStyle(
                                          color: cons.blanco,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            truncateText(
                                                document?['content'] ?? '',
                                                maxChars: 28),
                                            style: TextStyle(
                                              color: cons.gris,
                                            ),
                                          ),
                                          SizedBox(height: 4.0),
                                          Text(
                                            DateFormat('dd-MM-yyyy').format(
                                                document?['date']?.toDate() ??
                                                    DateTime.now()),
                                            style: TextStyle(
                                              color: cons.gris,
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.visibility),
                                            color: cons.gris,
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewTask(
                                                    TaskID: document?[
                                                            'documentId'] ??
                                                        '-1',
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            color: cons.gris,
                                            onPressed: () async {
                                              await deleteTask(
                                                  document?['documentId'] ??
                                                      '-1');
                                              _showSnackbar(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: Text(
                                'Agrega tareas notas',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            );
                          }
                        }
                      },
                    )
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
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    orderByField = 'title';
                  });
                },
                child: Text('Ordenar por Título'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    orderByField = 'date';
                  });
                },
                child: Text('Ordenar por Fecha'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String truncateText(String text, {int maxChars = 50}) {
  if (text.length <= maxChars) {
    return text;
  } else {
    return '${text.substring(0, maxChars)}...';
  }
}

void _showSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Borrando...'),
      backgroundColor: Color.fromARGB(255, 57, 57, 57),
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.fixed,
    ),
  );
  // Espera 3 segundos antes de navegar a otra pantalla
  Timer(const Duration(seconds: 3), () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
    );
  });
}




import 'dart:async';

import 'package:app_notes/navbar.dart';
import 'package:app_notes/services/firebase_service.dart';
import 'package:app_notes/taskedit.dart';
import 'package:app_notes/utils/singleton.dart';
import 'package:app_notes/viewtask.dart';
import 'package:flutter/material.dart';
import 'package:app_notes/utils/cons.dart' as cons;
import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:intl/intl.dart';

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
                      builder: (context,
                          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          if (snapshot.data != null &&
                              snapshot.data!.isNotEmpty) {
                            // Lista de tareas no vacía
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                var document = snapshot.data![index];
                                return Card(
                                  color: Colors.transparent,
                                  margin: EdgeInsets.all(6.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: cons.cardfill,
                                    ),
                                    child: ListTile(
                                      leading: Container(
                                        alignment: Alignment.center,
                                        width: 40.0,
                                        child: Icon(
                                          Icons.list,
                                          color: cons.gris,
                                        ),
                                      ),
                                      title: Text(
                                        document?['title'] ?? '',
                                        style: TextStyle(
                                          color: cons.blanco,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            truncateText(
                                                document?['content'] ?? '',
                                                maxChars: 28),
                                            style: TextStyle(
                                              color: cons.gris,
                                            ),
                                          ),
                                          SizedBox(height: 4.0),
                                          Text(
                                            DateFormat('dd-MM-yyyy').format(
                                                document?['date']?.toDate() ??
                                                    DateTime.now()),
                                            style: TextStyle(
                                              color: cons.gris,
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.visibility),
                                            color: cons.gris,
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ViewTask(
                                                    TaskID: document?[
                                                            'documentId'] ??
                                                        '-1',
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            color: cons.gris,
                                            onPressed: () async {
                                              await deleteTask(
                                                document?['documentId'] ?? '-1',
                                              );
                                              _showSnackbar(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            // Lista de tareas vacía
                            return Center(
                              child: Text(
                                'Agrega tareas notas',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            );
                          }
                        }
                      },
                    )
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

String truncateText(String text, {int maxChars = 50}) {
  if (text.length <= maxChars) {
    return text;
  } else {
    return '${text.substring(0, maxChars)}...';
  }
}

void _showSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Borrando...'),
      backgroundColor: Color.fromARGB(255, 57, 57, 57),
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.fixed,
    ),
  );
  // Espera 3 segundos antes de navegar a otra pantalla
  Timer(const Duration(seconds: 3), () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
    );
  });
}
*/