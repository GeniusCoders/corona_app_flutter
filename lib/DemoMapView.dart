import 'package:coronaapp/Model/model.dart';
import 'package:coronaapp/style/colors.dart';
import 'package:coronaapp/widgets/CountryListView.dart';
import 'package:coronaapp/widgets/CustomSwitch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'Service/service.dart';
import 'Theme/ThemeProvider.dart';
import 'Widgets/CountryPopUp.dart';

class DemoMapview extends StatefulWidget {
  DemoMapview();
  @override
  _DemoMapviewState createState() => _DemoMapviewState();
}

class _DemoMapviewState extends State<DemoMapview>
    with TickerProviderStateMixin {
  TextEditingController editcontroller = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late FocusNode _focus;
  double selectedLat = 0.0;
  double selectedLang = 0.0;
  double top = 80;
  List<CountryData> list = [];
  List<CountryData> filterItem = [];
  MapController? mapController;
  List<Marker>? _markers;
  int selectedRouteIndex = 0;
  String selectedFilter = "Total cases";

  @override
  void initState() {
    super.initState();
    loadCountryData().then((v) => {
          setState(
            () => list = v,
          ),
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
      filterItem.clear();
      list.forEach((
        item,
      ) {
        if (selectedFilter == 'Deaths' && item.totalDeaths != '0') {
          filterItem.add(item);
        } else if (selectedFilter == 'Recoveries' &&
            item.totalRecovered != '0') {
          filterItem.add(item);
        } else if (selectedFilter == 'Total cases' && item.totalCases != '0') {
          filterItem.add(item);
        }
      });
      setState(() {
        selectedRouteIndex = 1;
        selectedLang = 0.0;
        selectedLat = 0.0;
      });
    } else if (!_focus.hasFocus) {
      setState(() {
        selectedRouteIndex = 0;
      });
    }
  }

  setMarkerFilter(n) {
    double lat = n.latitude;
    double long = n.longitude;

    switch (selectedFilter) {
      case 'Total cases':
        return markerView(lat, long, pink);

      case 'Deaths':
        return n.totalDeaths != '0'
            ? markerView(lat, long, purple)
            : SizedBox();

      case 'Recoveries':
        return n.totalRecovered != '0'
            ? markerView(lat, long, green)
            : SizedBox();
    }
  }

  Container markerView(lat, long, color) {
    Color selectColor = selectedLat == lat && selectedLang == long
        ? blue.withOpacity(.2)
        : color.withOpacity(.2);
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
          color: selectColor,
          border: Border.all(
              width: 1.7,
              color: selectedLat == lat && selectedLang == long ? blue : color),
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );
  }

  void setMarkers() async {
    List<Marker> markers = [];
    bool notNull(Object o) => o != null;
    markers = list.map((n) {
      double lat = n.latitude!;
      double long = n.longitude!;

      LatLng point = LatLng(lat, long);
      return Marker(
        width: 290,
        height: 230,
        point: point,
        anchorPos: AnchorPos.align(AnchorAlign.bottom),
        builder: (ctx) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
                onTap: () => _setToolTipShow(lat, long),
                child: setMarkerFilter(n)),
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
    List<CountryData> dublicateSearchList = <CountryData>[];
    dublicateSearchList.addAll(list);
    if (text.isNotEmpty) {
      List<CountryData> dummyListData = <CountryData>[];
      dublicateSearchList.forEach((item) {
        if (item.countryName!.toLowerCase().contains(text.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        filterItem.clear();
        filterItem.addAll(dummyListData);
      });

      return;
    } else {
      setState(() {
        filterItem.clear();
        filterItem.addAll(list);
      });
    }
  }

  void _animatedMapMove(double lat, double long, double destZoom) {
    filterItem.clear();
    editcontroller.clear();
    _focus.unfocus();
    final _latTween =
        Tween<double>(begin: mapController!.center.latitude, end: lat);
    final _lngTween =
        Tween<double>(begin: mapController!.center.longitude, end: long);
    final _zoomTween = Tween<double>(begin: mapController!.zoom, end: destZoom);

    var controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController!.move(
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
    editcontroller.clear();
    filterItem.clear();
    setState(() {
      selectedRouteIndex = 0;
    });
  }

  Widget bottomSheetView() {
    return Container(
      height: 260,
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Filter',
                style: Theme.of(context).textTheme.title,
              ),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.times, size: 20),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
          bottomListTiles('Total cases', pink),
          bottomListTiles('Deaths', purple),
          bottomListTiles('Recoveries', green),
        ],
      ),
    );
  }

  ListTile bottomListTiles(String title, Color color) {
    return ListTile(
      onTap: () {
        if (selectedFilter != title) {
          setState(() {
            selectedFilter = title;
            selectedLat = 0;
            selectedLang = 0;
          });
        }

        Navigator.of(context).pop();
      },
      leading: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: color),
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: color.withOpacity(.2)),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.title,
      ),
    );
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
              color: themeProvider.isLightTheme ? lightBlack : white,
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
                        icon: FaIcon(
                          FontAwesomeIcons.bars,
                          size: 18,
                        ),
                        onPressed: () {
                          _scaffoldKey.currentState.openDrawer();
                        },
                      )
                    : IconButton(
                        icon: FaIcon(FontAwesomeIcons.angleLeft),
                        onPressed: () => onMenu()),
                Expanded(
                  child: TextField(
                    controller: editcontroller,
                    onChanged: (value) {
                      onSearchTextChanged(value);
                    },
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
                IconButton(
                    icon: FaIcon(
                      FontAwesomeIcons.filter,
                      size: 18,
                    ),
                    onPressed: () {
                      _focus.unfocus();
                      _scaffoldKey.currentState
                          .showBottomSheet((context) => bottomSheetView());
                    })
              ],
            ),
          ),
        ),
      ],
    );
  }

  TextStyle getSelectedTextTheme(myRouetIndex) {
    return selectedRouteIndex == myRouetIndex
        ? TextStyle(color: pink, fontSize: 16, fontWeight: FontWeight.w600)
        : Theme.of(context).textTheme.subtitle;
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
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.mapMarkerAlt,
                size: 18,
                color: iconColor,
              ),
              title: Text('Map', style: getSelectedTextTheme(0)),
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.fontAwesomeFlag,
                size: 18,
                color: iconColor,
              ),
              onTap: () {
                Navigator.pop(context);
                if (selectedRouteIndex != 1) {
                  setState(() {
                    selectedRouteIndex = 1;
                  });
                }
                FocusScope.of(context).requestFocus(_focus);
              },
              title: Text('Countries', style: getSelectedTextTheme(1)),
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.book,
                size: 18,
                color: iconColor,
              ),
              onTap: () {
                if (selectedRouteIndex != 2) {
                  setState(() {
                    selectedRouteIndex = 2;
                  });
                }
              },
              title: Text('Credit & Source', style: getSelectedTextTheme(2)),
            ),
            ListTile(
              leading: FaIcon(
                FontAwesomeIcons.at,
                size: 18,
                color: iconColor,
              ),
              title: Text(
                'Contact us',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
              child: Text(
                'PREFERENCES',
                style: TextStyle(
                    color: iconColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: .3),
              ),
            ),
            ListTile(
              trailing: CustomSwitch(
                value: themeProvider.isLightTheme,
                onChanged: (val) {
                  themeProvider.setThemeData = val;
                },
              ),
              title: Text(
                'Theme',
                style: Theme.of(context).textTheme.titleSmall,
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

    final themeProvider = Provider.of<ThemeProvider>(context);

    String mapType;
    if (mapController != null) {
      if (themeProvider.isLightTheme) {
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
          _focus.hasFocus
              ? CountryListView(filterItem, _animatedMapMove, selectedFilter)
              : Container(),
          searchBar(themeProvider)
        ],
      ),
    );
  }
}
