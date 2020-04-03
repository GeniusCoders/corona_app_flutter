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

    Text textData(text, color) {
      return Text(
        text,
        style: TextStyle(fontSize: 18, color: color),
      );
    }

    Widget setTextData(index) {
      final text = widget.filterItem[index];
      switch (widget.selectedFilter) {
        case 'Total cases':
          return textData(text.totalCases, pink);
          break;

        case 'Deaths':
          return text.totalDeaths != '0'
              ? textData(text.totalDeaths, purple)
              : null;
          break;

        case 'Recoveries':
          return text.totalRecovered != '0'
              ? textData(text.totalRecovered, green)
              : null;
          break;
      }
      return SizedBox();
    }

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
              setTextData(index)
            ],
          ),
        ),
      );
    }

    Widget getDetails(index) {
      switch (widget.selectedFilter) {
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
      color: themeProvider.isLightTheme ? black : lightWhite,
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
                          return getDetails(index);
                        },
                      )
                    : SizedBox()),
          ),
        ],
      ),
    );
  }
}
