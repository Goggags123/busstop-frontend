import 'dart:convert';

import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import './bottom-navigation-bar.dart';

class Result extends StatefulWidget {
  final LocationData currentLocation;
  Result({Key key, this.currentLocation}) : super(key: key);
  @override
  _ResultState createState() => _ResultState(currentLocation);
}

class _ResultState extends State {
  List<Map> _data;
  final LocationData currentLocation;
  _ResultState(this.currentLocation);
  final int _currentIndex = 0;

  void _fetchData() async {
    LocationData body = currentLocation;
    Response res = await get('https://busstop-backend.herokuapp.com/api/gps');
    List<Map> data = (jsonDecode(res.body) as List).map((e) {
      return {
        '_id': e['id'],
        'date': e['date'],
        'latitude': e['latitude'],
        'longtitude': e['longtitude'],
      };
    }).toList();
    res = await delete('https://busstop-backend.herokuapp.com/api/gps?_id=' +
        data.last['_id'].toString());
    res = await post('https://busstop-backend.herokuapp.com/api/gps', body: {
      'latitude': body.latitude,
      'longtitude': body.longitude,
    });
    res = await get('https://busstop-backend.herokuapp.com/api/gps');
    data = (jsonDecode(res.body) as List).map((e) {
      return {
        '_id': e['id'],
        'date': e['date'],
        'latitude': e['latitude'],
        'longtitude': e['longtitude'],
      };
    }).toList();
    setState(() {
      _data = data;
    });
  }

  TableRow _getRow(String _date, String _latitude, String _longtitude) {
    return TableRow(
      children: [
        Container(
          child: Text(
            _date,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            textAlign: TextAlign.center,
          ),
          decoration: BoxDecoration(border: Border.all()),
        ),
        Container(
          child: Text(
            _latitude,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
            textAlign: TextAlign.center,
          ),
          decoration: BoxDecoration(border: Border.all()),
        ),
        Container(
          child: Text(
            _longtitude,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
            textAlign: TextAlign.center,
          ),
          decoration: BoxDecoration(border: Border.all()),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavBar(_currentIndex),
        appBar: AppBar(
          title: Text('Map'),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                'GPS',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Table(
                // defaultColumnWidth: FixedColumnWidth(500),
                children: [
                  TableRow(
                    children: [
                      Container(
                        child: Text(
                          'longtitude',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center,
                        ),
                        decoration: BoxDecoration(border: Border.all()),
                      ),
                      Container(
                        child: Text(
                          'latitude',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center,
                        ),
                        decoration: BoxDecoration(border: Border.all()),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Container(
                        child: Text(
                          (currentLocation != null)
                              ? currentLocation.longitude.toString()
                              : "",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center,
                        ),
                        decoration: BoxDecoration(border: Border.all()),
                      ),
                      Container(
                        child: Text(
                          (currentLocation != null)
                              ? currentLocation.latitude.toString()
                              : "",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center,
                        ),
                        decoration: BoxDecoration(border: Border.all()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                children: [
                  Table(children: [_getRow("Date", "Latitude", "Longtitude")]),
                  Table(
                    children: (_data != null)
                        ? _data
                            .map((location) => _getRow(
                                location['date'].toString(),
                                location['latitude'].toString(),
                                location['longtitude'].toString()))
                            .toList()
                        : [
                            TableRow(children: [Text('Nothing')])
                          ],
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _fetchData,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
