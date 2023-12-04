import 'dart:io';

import 'package:app_notes/home.dart';
import 'package:app_notes/services/firebase_service.dart';
import 'package:app_notes/setloc.dart';
import 'package:app_notes/utils/singleton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:app_notes/utils/cons.dart' as cons;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class TaskEdit extends StatefulWidget {
  final String TaskID;

  TaskEdit({required this.TaskID});

  @override
  State<TaskEdit> createState() => _TaskEditState();
}

class _TaskEditState extends State<TaskEdit> {
  Singleton sgl = Singleton();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  LatLng? SelectedLoc;
  double latitude = 0.0;
  double longitude = 0.0;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String imginkk = '0';

  @override
  void initState() {
    super.initState();
    _dateController.text = 'Fecha';
    if (widget.TaskID != '-1') {
      loadTaskData();
    }
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
          _dateController.text = 'Fecha';
        }

        _selectedDate = taskData['date']?.toDate() != DateTime(1969, 12, 31)
            ? taskData['date']?.toDate()
            : null;

        GeoPoint? location = taskData['location'];
        if (location != null) {
          latitude = location.latitude;
          longitude = location.longitude;
          SelectedLoc = LatLng(latitude, longitude);
        }
      });
    }
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;

      print('Ruta del archivo seleccionado: ${pickedFile!.path}');
    });
  }

  Future<String?> uploadFile() async {
    try {
      final path = 'files/${pickedFile!.name}';
      final file = File(pickedFile!.path!);
      final ref = FirebaseStorage.instance.ref().child(path);

      // Subir el archivo
      await ref.putFile(file);

      // Obtener la URL de descarga directamente
      final urlDownload = await ref.getDownloadURL();
      print('Download Link: $urlDownload');

      return urlDownload;
    } catch (error) {
      print('Error al subir el archivo: $error');
      return null;
    }
  }

  Future<void> checkAndRequestPermissions() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      selectFile();
    } else {
      var result = await Permission.storage.request();
      if (result.isGranted) {
        selectFile();
      } else {
        print('Permisos denegados');
      }
    }
  }

  Widget buildprogress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;

          return SizedBox(
            height: 16.00,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                ),
                Center(
                  child: Text(
                    '${(100 * progress).roundToDouble()}%',
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          );
        } else {
          return const SizedBox(height: 16.0);
        }
      });

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
                'Agregar una nota',
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
                              cursorColor: cons.azulF,
                            ),
                            SizedBox(height: 16.0),
                            TextField(
                              controller: _contentController,
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
                              cursorColor: cons.azulF,
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate:
                                            _selectedDate ?? DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100),
                                      );

                                      if (pickedDate != null &&
                                          pickedDate != _selectedDate) {
                                        setState(() {
                                          _selectedDate = pickedDate;
                                          print(_selectedDate.toString());
                                          _dateController.text =
                                              DateFormat('dd-MM-yy')
                                                  .format(_selectedDate!);
                                        });
                                      }
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
                                        vertical: 14.0,
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
                                      LatLng? ubicacionSeleccionada =
                                          await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Setloc(),
                                        ),
                                      );

                                      if (ubicacionSeleccionada != null) {
                                        setState(() {
                                          SelectedLoc = ubicacionSeleccionada;
                                          print(
                                              'Ubicación seleccionada: $ubicacionSeleccionada');
                                        });
                                      } else {
                                        print(
                                            'Selección de ubicación cancelada');
                                      }
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
                                        vertical: 10.0,
                                        horizontal: 24.0,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          SelectedLoc != null
                                              ? Icons.location_on
                                              : Icons.location_off,
                                          color: cons.negro,
                                          size: 24.0,
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          '',
                                          style: TextStyle(
                                            color: cons.negro,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5.0),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () async {
                                      await checkAndRequestPermissions();
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
                                        vertical: 11.0,
                                        horizontal: 24.0,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          pickedFile != null
                                              ? Icons.image
                                              : Icons.image_not_supported,
                                          color: cons.negro,
                                          size: 24.0,
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          '',
                                          style: TextStyle(
                                            color: cons.negro,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            TextButton(
                              onPressed: () async {
                                String title = _titleController.text;
                                String content = _contentController.text;
                                Timestamp date = _selectedDate != null
                                    ? Timestamp.fromDate(_selectedDate!)
                                    : Timestamp.fromMillisecondsSinceEpoch(0);
                                GeoPoint location = SelectedLoc != null
                                    ? GeoPoint(SelectedLoc!.latitude,
                                        SelectedLoc!.longitude)
                                    : GeoPoint(0, 0);
                                String userID = sgl.docIDuser;
                                String imglink = '0';

                                if (widget.TaskID == '-1') {
                                  if (pickedFile != null) {
                                    imglink = await uploadFile() ?? '0';
                                    await addTask(title, content, date,
                                        location, userID, imglink);
                                  } else {
                                    await addTask(title, content, date,
                                        location, userID, imglink);
                                  }
                                } else {
                                  if (pickedFile != null) {
                                    imglink = await uploadFile() ?? '0';
                                    await updateTask(
                                        widget.TaskID,
                                        title,
                                        content,
                                        date,
                                        location,
                                        userID,
                                        imglink);
                                  } else {
                                    await updateTask(
                                        widget.TaskID,
                                        title,
                                        content,
                                        date,
                                        location,
                                        userID,
                                        imglink);
                                  }
                                }

                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => Home()));
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
                                'Guardar Tarea',
                                style: TextStyle(
                                  color: cons.negro,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            buildprogress(),
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
      ),
    );
  }
}
