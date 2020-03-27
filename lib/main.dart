import 'dart:convert';

import 'package:coronaapp/Mapview.dart';
import 'package:coronaapp/country_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'demo.dart';

class CountryData {
  String countryName;
  String flags;
  String totalCases;
  String totalDeaths;
  String totalRecovered;
  String latitude;
  String longitude;

  CountryData(
      {this.countryName,
      this.flags,
      this.totalCases,
      this.totalDeaths,
      this.totalRecovered,
      this.latitude,
      this.longitude});

  factory CountryData.fromJson(Map<String, dynamic> json) {
    return CountryData(
      countryName: json['countryName'],
      flags: json['Flags'],
      totalCases: json['Total Cases'],
      totalDeaths: json['Total Deaths'],
      totalRecovered: json['Total Recovered'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

class CountryDataList {
  final List<CountryData> countryDatas;

  CountryDataList({
    this.countryDatas,
  });

  factory CountryDataList.fromJson(List<dynamic> parsedJson) {
    List<CountryData> countryDatas = new List<CountryData>();
    countryDatas = parsedJson.map((i) => CountryData.fromJson(i)).toList();

    return CountryDataList(countryDatas: countryDatas);
  }
}

Future<String> _loadCountryAsset() async {
  return await rootBundle.loadString('assets/output.json');
}

Future<CountryDataList> loadCountry() async {
  await wait(5);
  String jsonString = await _loadCountryAsset();
  final jsonResponse = json.decode(jsonString);
  return new CountryDataList.fromJson(jsonResponse);
}

Future wait(int seconds) {
  return new Future.delayed(Duration(seconds: seconds), () => {});
}

void main() async {
  runApp(Mapview());
}
