import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CountryPopUp extends StatelessWidget {
  final String flag;
  final String countryName;
  final String totalCases;
  final String recovery;
  final String deaths;

  const CountryPopUp({
    required this.flag,
    required this.countryName,
    required this.totalCases,
    required this.recovery,
    required this.deaths,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(left: 150, top: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: Theme.of(context).scaffoldBackgroundColor.withOpacity(.8),
          boxShadow: [
            BoxShadow(
                blurRadius: 6,
                offset: Offset(2, 0),
                color: Color.fromRGBO(0, 0, 0, 0.1),
                spreadRadius: 0)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    countryName,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: .6),
                  ),
                ),
                SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      totalCases,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .6),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Text(
                      'Total Cases',
                      style: TextStyle(fontSize: 12, letterSpacing: .2),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
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
                    Text(
                      'Recoveries',
                      style: TextStyle(fontSize: 12, letterSpacing: .2),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      deaths,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: .6),
                    ),
                    Text(
                      'Deaths',
                      style: TextStyle(fontSize: 12, letterSpacing: .2),
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
