class CountryDataList {
  final List<CountryData> countryData;

  CountryDataList({
    required this.countryData,
  });

  factory CountryDataList.fromJson(List<dynamic> parsedJson) {
    List<CountryData> countryData = <CountryData>[];
    countryData = parsedJson.map((i) => CountryData.fromJson(i)).toList();

    return new CountryDataList(countryData: countryData);
  }
}

class CountryData {
  String? countryName;
  String? flags;
  String? totalCases;
  String? totalDeaths;
  String? totalRecovered;
  double? latitude;
  double? longitude;

  CountryData({
    this.countryName,
    this.flags,
    this.totalCases,
    this.totalDeaths,
    this.totalRecovered,
    this.latitude,
    this.longitude,
  });

  factory CountryData.fromJson(Map<dynamic, dynamic> json) => CountryData(
      countryName: json['countryName'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      totalCases: json['Total Case'],
      totalRecovered: json['Total Recovered'],
      totalDeaths: json['Total Deaths'],
      flags: json['Flags']);
}
