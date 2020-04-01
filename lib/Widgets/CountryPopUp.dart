import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CountryPopUp extends StatelessWidget {
  final String flag;
  final String countryName;
  final String totalCases;
  final String recovery;
  final String deaths;

  const CountryPopUp({
    Key key,
    this.flag,
    this.countryName,
    this.totalCases,
    this.recovery,
    this.deaths,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: EdgeInsets.only(left: 140, top: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: Theme.of(context).backgroundColor.withOpacity(.5),
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
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
              child: SvgPicture.network(
                flag,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Text(
                  countryName,
                  style: Theme.of(context).textTheme.title,
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
