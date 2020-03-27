import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_svg/svg.dart';

class TableLayout extends StatefulWidget {
  @override
  _TableLayoutState createState() => _TableLayoutState();
}

class _TableLayoutState extends State<TableLayout> {
  Future<List<dynamic>> loadAsset() async {
    final myData = await rootBundle.loadString("assets/result.csv");
    List<List<dynamic>> csvTable =
        CsvToListConverter().convert(myData).toList();
    return csvTable;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadAsset(),
      builder: (_, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, pos) {
              return Container(
                color: pos % 2 == 0 ? Color(0xFF292929) : Color(0xFF2c2c2f),
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                child: Row(
                  children: <Widget>[
                    SvgPicture.network(
                      snapshot.data[pos][0].toString(),
                      width: 26,
                      height: 26,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: Text(
                      snapshot.data[pos][1].toString(),
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    )),
                    Text(
                      snapshot.data[pos][2].toString(),
                      style: TextStyle(fontSize: 18, color: Color(0xFFFF416C)),
                    )
                  ],
                ),
              );
            },
          );
        } else {
          return Text('no');
        }
      },
    );
  }
}
