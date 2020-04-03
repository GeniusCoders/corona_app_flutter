import 'package:coronaapp/Model/model.dart';
import 'package:coronaapp/Style/colors.dart';
import 'package:coronaapp/Theme/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class CountryListView extends StatefulWidget {
  final List<CountryData> filterItem;
  final Function _animatedMapMove;
  final String selectedFilter;

  const CountryListView(
      this.filterItem, this._animatedMapMove, this.selectedFilter);

  @override
  _CountryListViewState createState() => _CountryListViewState();
}

class _CountryListViewState extends State<CountryListView> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    Widget listView(index, color) {
      return GestureDetector(
        onTap: () => widget._animatedMapMove(widget.filterItem[index].latitude,
            widget.filterItem[index].longitude, 5.0),
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: <Widget>[
              SvgPicture.network(
                widget.filterItem[index].flags,
                width: 26,
                height: 26,
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Text(widget.filterItem[index].countryName,
                      style: Theme.of(context).textTheme.subtitle)),
              Text(
                widget.filterItem[index].totalCases,
                style: TextStyle(fontSize: 18, color: color),
              )
            ],
          ),
        ),
      );
    }

    Widget getDetails(selectedFilter, index) {
      switch (selectedFilter) {
        case 'Total cases':
          return listView(index, pink);
          break;

        case 'Deaths':
          return widget.filterItem[index].totalDeaths != '0'
              ? listView(index, purple)
              : null;
          break;

        case 'Recoveries':
          return widget.filterItem[index].totalRecovered != '0'
              ? listView(index, green)
              : null;
          break;
      }
      return SizedBox();
    }

    return Container(
      color: themeProvider.isLightTheme ? lightWhite : black,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 80,
            right: 15,
            left: 15,
            bottom: 0,
            child: Container(
                child: widget.filterItem.length != 0
                    ? ListView.builder(
                        itemCount: widget.filterItem.length,
                        itemBuilder: (context, index) {
                          return getDetails(widget.selectedFilter, index);
                        },
                      )
                    : SizedBox()),
          ),
        ],
      ),
    );
  }
}
