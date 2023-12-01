import 'package:app_notes/home.dart';
import 'package:app_notes/setloc.dart';
import 'package:app_notes/utils/singleton.dart';
import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:app_notes/utils/cons.dart' as cons;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TaskEdit extends StatefulWidget {
  final String TaskID;

  TaskEdit({required this.TaskID});

  @override
  State<TaskEdit> createState() => _TaskEditState();
}

class _TaskEditState extends State<TaskEdit> {
  Singleton sgl = Singleton();

  @override
  Widget build(BuildContext context) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _contentController = TextEditingController();
    TextEditingController _dateController = TextEditingController();
    DateTime? _selectedDate;
    LatLng? SelectedLoc;

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
                'Agregar una tarea',
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
                          paintingStyle: PaintingStyle.stroke,
                          strokeWidth: 8,
                          shape: BubbleShape.circle,
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
                              maxLines: 20,
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
                                          _dateController.text = _selectedDate!
                                              .toLocal()
                                              .toString();
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
                                        vertical: 16.0,
                                        horizontal: 24.0,
                                      ),
                                    ),
                                    child: Text(
                                      _selectedDate != null
                                          ? '${_selectedDate.toString()}'
                                          : 'Fecha',
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
                                        SelectedLoc = ubicacionSeleccionada;
                                        print(
                                            'Ubicación seleccionada: $ubicacionSeleccionada');
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
                                      String title = _titleController.text;
                                      String content = _contentController.text;

                                      print(
                                          'Título: $title, Contenido: $content');
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
                            const SizedBox(height: 16.0),
                            TextButton(
                              onPressed: () {
                                String title = _titleController.text;
                                String content = _contentController.text;
                                String fecha = _selectedDate.toString();
                                String loc = SelectedLoc.toString();

                                print('Título: $title, Contenido: $content');
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
                            )
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
