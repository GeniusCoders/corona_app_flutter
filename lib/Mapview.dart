import 'dart:convert';

import 'package:coronaapp/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong/latlong.dart';

class Mapview extends StatefulWidget {
  Mapview();
  @override
  _MapviewState createState() => _MapviewState();
}

class _MapviewState extends State<Mapview> {
  Color pink = Color(0xFFFF416C);
  Color blue = Color(0xFF294aff);
  double selectedLat = 0.0;
  double selectedLang = 0.0;
  CountryDataList countryData;
  bool _loaded = false;

  void _setToolTipShow(double lat, double lang) {
    setState(() {
      selectedLat = lat;
      selectedLang = lang;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCountry().then((s) => setState(() {
          countryData = s;
          _loaded = true;
        }));
    print(countryData.countryDatas);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
        options: MapOptions(
          maxZoom: 4,
          minZoom: 3,
          center: LatLng(20.5937, 78.9629),
          zoom: 13.0,
        ),
        layers: [
          TileLayerOptions(
              urlTemplate:
                  "https://api.maptiler.com/maps/positron/{z}/{x}/{y}.png?key=NdGiakn2BJ2BA8hWhBLN",
              subdomains: ['a', 'b', 'c']),
        ]);
  }
}

class CountryPopUp extends StatelessWidget {
  final String flag;
  final String countryName;

  const CountryPopUp({Key key, this.flag, this.countryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: EdgeInsets.only(left: 20, top: 30),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white.withOpacity(.8),
          boxShadow: [
            BoxShadow(
                blurRadius: 6,
                offset: Offset(2, 0),
                color: Color.fromRGBO(0, 0, 0, 0.1),
                spreadRadius: 0)
          ]),
      child: Column(
        children: <Widget>[
          Container(
            height: 80,
            child: SvgPicture.network(flag, fit: BoxFit.cover),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Text(
                  countryName,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: .6),
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '2000',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .6),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Total Cases',
                      style: TextStyle(fontSize: 12, letterSpacing: .6),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '10',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .6),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Recoveries',
                      style: TextStyle(fontSize: 12, letterSpacing: .6),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      '2',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .6),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Deaths',
                      style: TextStyle(fontSize: 12, letterSpacing: .6),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
