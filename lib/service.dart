import 'dart:async' show Future;
import 'package:coronaapp/model.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

Future<String> _loadPhotoAsset() async {
  return await rootBundle.loadString('assets/output.json');
}

Future<List<CountryData>> loadCountryData() async {
  await wait(2);
  String jsonPhotos = await _loadPhotoAsset();
  final jsonResponse = json.decode(jsonPhotos);
  CountryDataList countryDataList = CountryDataList.fromJson(jsonResponse);
  return countryDataList.countryData;
}

Future wait(int seconds) {
  return new Future.delayed(Duration(seconds: seconds), () => {});
}
