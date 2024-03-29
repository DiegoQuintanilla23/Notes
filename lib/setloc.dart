import 'package:app_notes/utils/singleton.dart';
import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:app_notes/utils/cons.dart' as cons;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class Setloc extends StatefulWidget {
  const Setloc({super.key});

  @override
  State<Setloc> createState() => _SetlocState();
}

class _SetlocState extends State<Setloc> {
  Singleton sgl = Singleton();
  late GoogleMapController mapController;
  LatLng initialPosition = LatLng(0.0, 0.0);
  LatLng selectedLocation = LatLng(0.0, 0.0);
  bool permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      await _getLocation();
      setState(() {
        permissionsGranted = true;
      });
    } else {
      print("Permiso de ubicación denegado");
    }
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        initialPosition = LatLng(position.latitude, position.longitude);
        selectedLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print("Error al obtener la ubicación: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!permissionsGranted) {
      // Si los permisos no se han concedido, puedes mostrar un indicador de carga o un mensaje.
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final size = MediaQuery.of(context).size;
    ThemeData currentTheme = sgl.isDarkMode ? cons.darkTheme : cons.lightTheme;

    Set<Marker> markers = {
      Marker(
        markerId: MarkerId('selectedLocation'),
        position: selectedLocation,
        draggable: true,
        onDragEnd: (newPosition) {
          setState(() {
            selectedLocation = newPosition;
          });
        },
      ),
    };

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
              Navigator.pop(context);
            },
            color: cons.negro,
          ),
          title: Row(
            children: [
              Text('|', style: TextStyle(fontSize: 24, color: cons.negro)),
              SizedBox(width: 50),
              Text(
                'Seleccionar Ubicación',
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
                margin: EdgeInsets.all(17.0),
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
                    GoogleMap(
                      onMapCreated: (controller) {
                        mapController = controller;
                      },
                      initialCameraPosition: CameraPosition(
                        target: initialPosition,
                        zoom: 18.0,
                      ),
                      markers: markers,
                      onTap: (position) {
                        setState(() {
                          selectedLocation = position;
                          markers.clear();
                          markers.add(
                            Marker(
                              markerId: MarkerId('selectedLocation'),
                              position: selectedLocation,
                              draggable: true,
                              onDragEnd: (newPosition) {
                                setState(() {
                                  selectedLocation = newPosition;
                                });
                              },
                            ),
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: cons.azulF,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(selectedLocation);
                },
                child: Text('Confirmar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancelar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
