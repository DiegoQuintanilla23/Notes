import 'package:app_notes/home.dart';
import 'package:app_notes/services/firebase_service.dart';
import 'package:app_notes/setloc.dart';
import 'package:app_notes/taskedit.dart';
import 'package:app_notes/utils/singleton.dart';
import 'package:app_notes/viewmap.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:app_notes/utils/cons.dart' as cons;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class ViewTask extends StatefulWidget {
  final String TaskID;

  ViewTask({required this.TaskID});

  @override
  State<ViewTask> createState() => _ViewTaskState();
}

class _ViewTaskState extends State<ViewTask> {
  Singleton sgl = Singleton();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  LatLng? SelectedLoc;
  double latitude = 0.0;
  double longitude = 0.0;
  String imginkk = '0';

  @override
  void initState() {
    super.initState();
    loadTaskData();
  }

  Future<void> loadTaskData() async {
    // Obtener datos de la tarea usando la función getTaskDataById.
    Map<String, dynamic>? taskData = await getTaskDataById(widget.TaskID);

    if (taskData != null) {
      setState(() {
        _titleController.text = taskData['title'];
        _contentController.text = taskData['content'];
        imginkk = taskData['imglink'];

        _dateController.text =
            DateFormat('dd-MM-yy').format(taskData?['date']?.toDate() ?? '');
        if (_dateController.text == '31-12-69') {
          _dateController.text = 'Sin Fecha';
        }

        GeoPoint? location = taskData['location'];
        if (location != null) {
          latitude = location.latitude;
          longitude = location.longitude;
        }
      });
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
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Home()));
            },
            color: cons.negro,
          ),
          title: const Row(
            children: [
              Text('|', style: TextStyle(fontSize: 24, color: cons.negro)),
              SizedBox(width: 50),
              Text(
                'Nota',
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
        body: SingleChildScrollView(
          child: Stack(
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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: _titleController,
                              enabled: false,
                              style: TextStyle(color: cons.negro),
                              decoration: InputDecoration(
                                fillColor: cons.controllerfill,
                                filled: true,
                                labelText: 'Título',
                                labelStyle: TextStyle(
                                  color:
                                      sgl.isDarkMode ? cons.blanco : cons.negro,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: cons.gris,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                    color: cons.negro,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            TextField(
                              controller: _contentController,
                              enabled: false,
                              maxLines: 20,
                              style: TextStyle(color: cons.negro),
                              decoration: InputDecoration(
                                fillColor: cons.controllerfill,
                                filled: true,
                                labelText: 'Contenido',
                                labelStyle: TextStyle(
                                  color:
                                      sgl.isDarkMode ? cons.blanco : cons.negro,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: cons.negro,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () async {},
                                    style: TextButton.styleFrom(
                                      backgroundColor: cons.azul,
                                      onSurface: cons.azulF,
                                      disabledForegroundColor: cons.azulF,
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16.0,
                                        horizontal: 24.0,
                                      ),
                                    ),
                                    child: Text(
                                      _dateController.text,
                                      style: const TextStyle(
                                        color: cons.negro,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5.0),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ViewMap(
                                              latitude: latitude,
                                              longitude: longitude),
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: cons.azul,
                                      onSurface: cons.azulF,
                                      disabledForegroundColor: cons.azulF,
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16.0,
                                        horizontal: 24.0,
                                      ),
                                    ),
                                    child: const Text(
                                      'Ubicación',
                                      style: TextStyle(
                                        color: cons.negro,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5.0),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text('Imagen'),
                                          content: imginkk != '0'
                                              ? Image.network(
                                                  imginkk,
                                                  width: size.width * 0.23,
                                                  height: size.height * 0.25,
                                                  fit: BoxFit.cover,
                                                )
                                              : const Text('No hay imagen'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Cancelar'),
                                              child: const Text('Cerrar'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: cons.azul,
                                      onSurface: cons.azulF,
                                      disabledForegroundColor: cons.azulF,
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16.0,
                                        horizontal: 24.0,
                                      ),
                                    ),
                                    child: const Text(
                                      'Imagen',
                                      style: TextStyle(
                                        color: cons.negro,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TaskEdit(
                  TaskID: widget.TaskID,
                ),
              ),
            );
          },
          child: Icon(Icons.edit),
          backgroundColor: Color.fromARGB(132, 71, 199, 225),
        ),
      ),
    );
  }
}
