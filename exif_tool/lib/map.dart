import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import '/utils/utils.dart';
import '/utils/tile_servers.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:map/map.dart';
import 'package:latlng/latlng.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {

  const MapPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final controller = MapController(
    location: const LatLng(51.620790309758355, -3.8802971905375068),
  );

  Future<void> _gotoDefault() async {
    // controller.center = const LatLng(51.620790309758355, -3.8802971905375068);
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      controller.center = const LatLng(51.620790309758355, -3.8802971905375068);
      setState(() {});
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    controller.center = LatLng(position.latitude, position.longitude);
    setState(() {});
  }


  void _onDoubleTap(MapTransformer transformer, Offset position) {
    const delta = 0.5;
    final zoom = clamp(controller.zoom + delta, 2, 18);

    transformer.setZoomInPlace(zoom, position);
    setState(() {});
  }

  Offset? _dragStart;
  double _scaleStart = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details, MapTransformer transformer) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      controller.zoom += 0.02;
      setState(() {});
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.02;
      setState(() {});
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart!;
      _dragStart = now;
      transformer.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: MapLayout(
        controller: controller,
        builder: (context, transformer) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onDoubleTapDown: (details) => _onDoubleTap(
              transformer,
              details.localPosition,
            ),
            onScaleStart: _onScaleStart,
            onScaleUpdate: (details) => _onScaleUpdate(details, transformer),
            onTapUp: (details) {
              final location = transformer.toLatLng(details.localPosition);

              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  title: const Text("Select Location"),
                  children: <Widget>[
                    Text(
                      "Latitude: ${location.latitude}, Longitude: ${location.longitude}",
                      textAlign: TextAlign.center,
                    ),
                    SimpleDialogOption(
                      child: ElevatedButton(
                        onPressed: () { Navigator.pop(context, location); },
                        child: const Text("Select"),
                      ),
                    ),
                    SimpleDialogOption(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red
                        ),
                        onPressed: () { Navigator.pop(context); },
                        child: const Text("Cancel"),
                      )
                    )
                  ],
                ),
              ).then((value) {
                if (value != null) {
                  Navigator.pop(context, value);
                }
              });
            },
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  final delta = event.scrollDelta.dy / -100.0;
                  final zoom = clamp(controller.zoom + delta, 2, 18);

                  transformer.setZoomInPlace(zoom, event.localPosition);
                  setState(() {});
                }
              },
              child: Stack(
                children: [
                  TileLayer(
                    builder: (context, x, y, z) {
                      final tilesInZoom = pow(2.0, z).floor();

                      while (x < 0) {
                        x += tilesInZoom;
                      }
                      while (y < 0) {
                        y += tilesInZoom;
                      }

                      x %= tilesInZoom;
                      y %= tilesInZoom;

                      return CachedNetworkImage(
                        imageUrl: google(z, x, y),
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _gotoDefault,
        tooltip: 'My Location',
        child: const Icon(Icons.my_location),
      ),
    );
  }


  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return false;
    }
    return true;
  }
}