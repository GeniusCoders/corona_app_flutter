import 'package:coronaapp/CustomInfoWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong/latlong.dart';

import 'model.dart';
import 'service.dart';

class PointObject {
  final Widget child;
  final LatLng location;

  PointObject({this.child, this.location});
}

class DemoMapview extends StatefulWidget {
  DemoMapview();
  @override
  _DemoMapviewState createState() => _DemoMapviewState();
}

class _DemoMapviewState extends State<DemoMapview>
    with TickerProviderStateMixin {
  TextEditingController editcontroller = new TextEditingController();
  FocusNode _focus;
  Color pink = Color(0xFFFF416C);
  Color blue = Color(0xFF294aff);
  double selectedLat = 0.0;
  double selectedLang = 0.0;
  double top = 80;
  bool loaded = false;
  List<CountryData> list = [];
  List<CountryData> filterItem = [];
  MapController mapController;
  InfoWidgetRoute _infoWidgetRoute;
  PointObject point = PointObject(
    child: Text('India'),
    location: LatLng(20.30, 78.8796),
  );

  List<Marker> _markers;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCountryData().then((v) => {
          setState(() => {list = v, loaded = true}),
        });
    mapController = MapController();
    _focus = FocusNode();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    editcontroller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _setToolTipShow(double lat, double lang) {
    setState(() {
      selectedLat = lat;
      selectedLang = lang;
    });
  }

  void _onFocusChange() {
    if (_focus.hasFocus) {
      setState(() {});
    } else if (!_focus.hasFocus) {
      setState(() {});
    }
  }

  void setMarkers() async {
    var notes = list;
    List<Marker> markers = [];

    markers = notes.map((n) {
      double lat = n.latitude;
      double long = n.longitude;
      Color selectColor = selectedLat == lat && selectedLang == long
          ? blue.withOpacity(.3)
          : pink.withOpacity(.3);
      LatLng point = LatLng(lat, long);
      return Marker(
        width: 200,
        height: 200,
        point: point,
        builder: (ctx) => Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: GestureDetector(
                onTap: () => _setToolTipShow(lat, long),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      color: selectColor,
                      border: Border.all(
                          width: 2,
                          color: selectedLat == lat && selectedLang == long
                              ? blue
                              : pink),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
              ),
            ),
            selectedLat == lat && selectedLang == long
                ? CountryPopUp(
                    flag: n.flags,
                    countryName: n.countryName,
                    totalCases: n.totalCases,
                    recovery: n.totalRecovered,
                    deaths: n.totalDeaths,
                  )
                : Container()
          ],
        ),
      );
    }).toList();

    setState(() {
      _markers = markers;
    });
  }

  onSearchTextChanged(String text) async {
    filterItem.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    list.forEach((item) {
      if (item.countryName.toLowerCase().contains(text.toLowerCase())) {
        filterItem.add(item);
      }
    });
    setState(() {});
  }

  void _animatedMapMove(double lat, double long, double destZoom) {
    filterItem.clear();
    editcontroller.clear();
    _focus.unfocus();
    final _latTween =
        Tween<double>(begin: mapController.center.latitude, end: lat);
    final _lngTween =
        Tween<double>(begin: mapController.center.longitude, end: long);
    final _zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    var controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
    _setToolTipShow(lat, long);
  }

  void onMenu() {
    _focus.unfocus();
    setState(() {});
  }

  Widget searchBar() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 50,
          right: 15,
          left: 15,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    blurRadius: 6,
                    offset: Offset(2, 0),
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    spreadRadius: 0)
              ],
            ),
            child: Row(
              children: <Widget>[
                !_focus.hasFocus
                    ? IconButton(
                        splashColor: Colors.grey,
                        icon: Icon(Icons.menu),
                        onPressed: () {},
                      )
                    : IconButton(
                        splashColor: Colors.grey,
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 18,
                        ),
                        onPressed: () {
                          onMenu();
                        },
                      ),
                Expanded(
                  child: TextField(
                    controller: editcontroller,
                    onChanged: onSearchTextChanged,
                    focusNode: _focus,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        hintText: "Search regions"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget searchCountryList() {
    return Container(
      color: Color(0xFFF5F5F5),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: top,
            right: 15,
            left: 15,
            bottom: 0,
            child: Container(
                child: filterItem.length != 0 || editcontroller.text.isNotEmpty
                    ? ListView.builder(
                        itemCount: filterItem.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => _animatedMapMove(
                                filterItem[index].latitude,
                                filterItem[index].longitude,
                                5.0),
                            child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              child: Row(
                                children: <Widget>[
                                  SvgPicture.network(
                                    filterItem[index].flags,
                                    width: 26,
                                    height: 26,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                      child: Text(
                                    filterItem[index].countryName,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  )),
                                  Text(
                                    filterItem[index].totalCases,
                                    style: TextStyle(
                                        fontSize: 18, color: Color(0xFFFF416C)),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : SizedBox()),
          ),
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: .3,
      minChildSize: 0.1,
      maxChildSize: .8,
      builder: (BuildContext context, myscrollController) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular((20)))),
          child: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              controller: myscrollController,
              child: Column(children: <Widget>[
                Container(
                  width: 40,
                  height: 6,
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      height: 36,
                      width: 36,
                      margin: EdgeInsets.only(left: 30, right: 20),
                      child: SvgPicture.network(
                          'https://coronavirus.app/assets/img/flags/IN.svg',
                          fit: BoxFit.cover),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'India',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            letterSpacing: .6),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () {},
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[Deatils(), Deatils()],
                )
              ])),
        );
      },
    );
  }

  // _onTap(PointObject point) {
  //   print('hello');
  //   final RenderBox renderBox = context.findRenderObject();
  //   Rect _itemRect = renderBox.localToGlobal(Offset.zero) & renderBox.size;
  //   print(_itemRect);
  //   _infoWidgetRoute = InfoWidgetRoute(
  //     child: point.child,
  //     buildContext: context,
  //     textStyle: const TextStyle(
  //       fontSize: 14,
  //       color: Colors.black,
  //     ),
  //     mapsWidgetSize: _itemRect,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    setMarkers();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          FlutterMap(
              mapController: mapController,
              options: MapOptions(
                maxZoom: 5,
                minZoom: 3,
                center: LatLng(20.5937, 78.9629),
                zoom: 13.0,
                onTap: (latLng) {
                  _setToolTipShow(0, 0);
                },
              ),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        "https://api.maptiler.com/maps/positron/{z}/{x}/{y}.png?key=NdGiakn2BJ2BA8hWhBLN",
                    subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(markers: _markers)
              ]),
          _focus.hasFocus ? searchCountryList() : Container(),
          searchBar(),
        ],
      ),
    );
  }
}

class Deatils extends StatelessWidget {
  final String title;
  final String subtitle;

  const Deatils({Key key, this.title = "102", this.subtitle = "Total death"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 90,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            subtitle,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                letterSpacing: .4),
          )
        ],
      ),
    );
  }
}

class CountryPopUp extends StatelessWidget {
  final String flag;
  final String countryName;
  final String totalCases;
  final String recovery;
  final String deaths;
  final LayerLink link;
  const CountryPopUp(
      {Key key,
      this.flag = "https://coronavirus.app/assets/img/flags/AO.svg",
      this.countryName = "Cuba Nuba",
      this.totalCases = "1200",
      this.recovery = "200",
      this.deaths = "10",
      this.link})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: EdgeInsets.only(left: 20, top: 20),
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
                        totalCases,
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
                        recovery,
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
                      deaths,
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
