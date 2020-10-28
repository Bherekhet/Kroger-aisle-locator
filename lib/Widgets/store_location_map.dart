import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/store_info.dart';
import '../Widgets/store_location_store.dart';

class StoreLocationMap extends StatefulWidget {
  final List<StoreInfo> stores;
  StoreLocationMap({this.stores});

  @override
  _StoreLocationMapState createState() => _StoreLocationMapState();
}

class _StoreLocationMapState extends State<StoreLocationMap> {
  GoogleMapController mapController;
  bool storeLoaded = false;
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  _updateMap(dynamic stores) {
    _markers.clear();
    setState(() {
      stores.forEach((element) {
        _markers.add(
          Marker(
            markerId: MarkerId(element.id),
            position: LatLng(element.latitude, element.longtide),
            infoWindow: InfoWindow(title: element.name, snippet: element.city),
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
      });
    });
  }

  _animateCameraPosition(LatLng loc) {
    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: loc,
        tilt: 50.0,
        zoom: 10.0,
      )));
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    final store = widget.stores;
    if (store != null && store.isNotEmpty) {
      _updateMap(store);
      setState(() {
        storeLoaded = true;
        _animateCameraPosition(LatLng(store[0].latitude, store[0].longtide));
      });
    }

    return Stack(
      children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition:
              CameraPosition(target: LatLng(0, 0), zoom: 2.0),
          markers: _markers,
          onCameraMove: (_) {
            if (storeLoaded) {
              CameraPosition(
                  target: LatLng(store[0].latitude, store[0].longtide),
                  zoom: 10.0);
            }
          },
        ),
        Positioned(
          right: 10.0,
          left: 10.0,
          bottom: 100.0,
          child: Container(
            margin: EdgeInsets.only(left: 10),
            height: 100,
            child: store != null
                ? ListView.builder(
                    itemCount: store.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) => StoreLocationStore(
                      id: store[i].id,
                      name: store[i].name,
                      address: store[i].addressLine,
                      city: store[i].city,
                      state: store[i].state,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
