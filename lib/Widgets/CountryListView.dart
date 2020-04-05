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
    return ListTile(
      onTap: () => widget._animatedMapMove(widget.filterItem[index].latitude,
          widget.filterItem[index].longitude, 5.0),
      leading: SvgPicture.network(
        widget.filterItem[index].flags,
        width: 26,
        height: 26,
      ),
      title: Text(widget.filterItem[index].countryName,
          style: Theme.of(context).textTheme.subtitle),
      trailing: setTextData(index),
    );
  }

  Color getDetails() {
    switch (widget.selectedFilter) {
      case 'Total cases':
        return pink;
        break;

      case 'Deaths':
        return purple;
        break;

      case 'Recoveries':
        return green;
        break;
    }
    return black;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
                          return listView(index, getDetails());
                        },
                      )
                    : SizedBox()),
          ),
        ],
      ),
    );
  }
}
