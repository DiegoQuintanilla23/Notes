import 'package:app_notes/utils/singleton.dart';
import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:app_notes/utils/cons.dart' as cons;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewMap extends StatefulWidget {
  final double latitude;
  final double longitude;

  const ViewMap({Key? key, required this.latitude, required this.longitude})
      : super(key: key);

  @override
  State<ViewMap> createState() => _ViewMapState();
}

class _ViewMapState extends State<ViewMap> {
  Singleton sgl = Singleton();
  late GoogleMapController mapController;
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
              Navigator.pop(context);
            },
            color: cons.negro,
          ),
          title: Row(
            children: [
              Text('|', style: TextStyle(fontSize: 24, color: cons.negro)),
              SizedBox(width: 50),
              Text(
                'Ubicación',
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
                        target: LatLng(widget.latitude, widget.longitude),
                        zoom: 18.0,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId('markerId'),
                          position: LatLng(widget.latitude, widget.longitude),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueBlue),
                          infoWindow: InfoWindow(
                            title: 'Ubicación Guardada',
                            snippet:
                                'Lat: ${widget.latitude}, Lng: ${widget.longitude}',
                          ),
                        ),
                      },
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
