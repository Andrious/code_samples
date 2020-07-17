// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:math' show Random, pow;
import 'package:flutter/material.dart';

import 'alarm_manager.dart' show AlarmManager;
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

/// The [SharedPreferences] key to access the alarm fire count.
const String _countKey = 'count';

/// Global [SharedPreferences] object.
SharedPreferences _prefs;

void main() => runApp(AlarmManagerExampleApp());

class AlarmManagerExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<bool>(
            future: initSettings(),
            initialData: false,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return _AlarmHomePage(
                    title: 'Notification & Alarms in Flutter');
              } else {
                return Container(
                    child: Center(child: CircularProgressIndicator()));
              }
            }));
  }

  Future<bool> initSettings() async {
    bool init = await AlarmManager.init();
//    bool init = await AlarmManager.init(
//      exact: true,
//      alarmClock: true,
//      wakeup: true,
//    );
    _prefs = await SharedPreferences.getInstance();
    if (!_prefs.containsKey(_countKey)) _prefs.setInt(_countKey, 0);
 //   return init;
    return true;
  }
}

class _AlarmHomePage extends StatefulWidget {
  _AlarmHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _AlarmHomePageState createState() => _AlarmHomePageState();
}

class _AlarmHomePageState extends State<_AlarmHomePage> {
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headline4;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Alarm fired $_counter times',
              style: textStyle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Total alarms fired: ',
                  style: textStyle,
                ),
                Text(
                  _prefs.getInt(_countKey).toString(),
                  key: ValueKey('BackgroundCountText'),
                  style: textStyle,
                ),
              ],
            ),
            RaisedButton(
              child: Text(
                'Schedule OneShot Alarm',
              ),
              key: ValueKey('RegisterOneShotAlarm'),
              onPressed: () async {
                await AlarmManager.init(
                  exact: true,
                  alarmClock: true,
                  wakeup: true,
                );
                await AlarmManager.oneShot(
                  const Duration(seconds: 5),
                  // Ensure we have a unique alarm ID.
                  Random().nextInt(pow(2, 31)),
                  (int id) => _incrementCounter(),
                );

                if (AlarmManager.hasError) print(AlarmManager.getError());
              },
            ),
          ],
        ),
      ),
    );
  }

  int _counter = 0;
  Future<void> _incrementCounter() async {
    int currentCount = _prefs.getInt(_countKey);
    await _prefs.setInt(_countKey, currentCount + 1);
    // Ensure we've loaded the updated count from the background isolate.
    await _prefs.reload();
    setState(() {
      _counter++;
    });
    print('Increment counter!');
  }
}
