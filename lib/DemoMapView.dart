import 'package:coronaapp/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

import 'Theme/ThemeProvider.dart';
import 'Widgets/CountryPopUp.dart';
import 'Model/model.dart';
import 'Service/service.dart';

class DemoMapview extends StatefulWidget {
  DemoMapview();
  @override
  _DemoMapviewState createState() => _DemoMapviewState();
}

class _DemoMapviewState extends State<DemoMapview>
    with TickerProviderStateMixin {
  TextEditingController editcontroller = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
  List<Marker> _markers;

  @override
  void initState() {
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
    bool notNull(Object o) => o != null;
    markers = notes.map((n) {
      double lat = n.latitude;
      double long = n.longitude;
      Color selectColor = selectedLat == lat && selectedLang == long
          ? blue.withOpacity(.3)
          : pink.withOpacity(.3);
      LatLng point = LatLng(lat, long);
      return Marker(
        width: 280,
        height: 200,
        point: point,
        anchorPos: AnchorPos.align(AnchorAlign.bottom),
        builder: (ctx) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () => _setToolTipShow(lat, long),
              child: Container(
                width: 20,
                height: 20,
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
            selectedLat == lat && selectedLang == long
                ? CountryPopUp(
                    flag: n.flags,
                    countryName: n.countryName,
                    totalCases: n.totalCases,
                    recovery: n.totalRecovered,
                    deaths: n.totalDeaths,
                  )
                : null
          ].where(notNull).toList(),
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

  Widget searchBar(ThemeProvider themeProvider) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 50,
          right: 15,
          left: 15,
          child: Container(
            decoration: BoxDecoration(
              color: themeProvider.isLightTheme ? white : lightBlack,
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
                        icon: Icon(Icons.menu),
                        onPressed: () {
                          _scaffoldKey.currentState.openDrawer();
                        },
                      )
                    : IconButton(
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

  Widget searchCountryList(ThemeProvider themeProvider) {
    return Container(
      color: themeProvider.isLightTheme ? lightWhite : black,
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
                              color: Colors.transparent,
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
                                      child: Text(filterItem[index].countryName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle)),
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

  Widget setDrawer(ThemeProvider themeProvider) {
    return Drawer(
      child: Container(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 20, 30),
              child: Text(
                'The Coronavirus App',
                style: Theme.of(context).textTheme.title,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.location_on,
                color: Color(0xFFAFAFAF),
              ),
              title: Text(
                'Map',
                style: Theme.of(context).textTheme.subtitle,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.flag,
                color: Color(0xFFAFAFAF),
              ),
              title: Text(
                'Countries',
                style: Theme.of(context).textTheme.subtitle,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.book,
                color: Color(0xFFAFAFAF),
              ),
              title: Text(
                'Credit & Source',
                style: Theme.of(context).textTheme.subtitle,
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.alternate_email,
                color: Color(0xFFAFAFAF),
              ),
              title: Text(
                'Contact us',
                style: Theme.of(context).textTheme.subtitle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
              child: Text(
                'PREFERENCES',
                style: TextStyle(
                    color: Color(0xFFAFAFAF),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: .3),
              ),
            ),
            ListTile(
              trailing: Switch(
                value: themeProvider.isLightTheme,
                onChanged: (val) {
                  themeProvider.setThemeData = val;
                },
              ),
              title: Text(
                'Theme',
                style: Theme.of(context).textTheme.subtitle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setMarkers();
    bool isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    final themeProvider = Provider.of<ThemeProvider>(context);

    String mapType;
    if (mapController != null) {
      if (isDark) {
        mapType = "darkmatter";
      } else {
        mapType = "positron";
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: setDrawer(themeProvider),
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
                        "https://api.maptiler.com/maps/$mapType/{z}/{x}/{y}.png?key=NdGiakn2BJ2BA8hWhBLN",
                    subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(markers: _markers)
              ]),
          _focus.hasFocus ? searchCountryList(themeProvider) : Container(),
          searchBar(themeProvider),
        ],
      ),
    );
  }
}
