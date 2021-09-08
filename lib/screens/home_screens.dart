import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'package:rss_parse/common/fetch_http_habs.dart';
import 'package:rss_parse/screens/read_screens.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class HomeScreenRSS extends StatefulWidget {
  const HomeScreenRSS({Key? key}) : super(key: key);

  @override
  _HomeScreenRSSState createState() => _HomeScreenRSSState();
}

class _HomeScreenRSSState extends State<HomeScreenRSS> {
  bool _darkTheme = false;
  List _habsList = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: !_darkTheme ? ThemeData.light() : ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Habr RSS'),
          actions: [
            Icon(_getAppBarIcon()),
            _getPlatformSwitch(),
          ],
        ),
        body: FutureBuilder(
          future: _getHttpHabs(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container(
                child: ListView.builder(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
                  scrollDirection: Axis.vertical,
                  itemCount: _habsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Column(
                          children: [
                            Text(
                              '${_habsList[index].title}',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              '${parseDescription(_habsList[index].description)}',
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(DateFormat('dd.mm.yyyy kk:mm').format(
                                    DateTime.parse(
                                        '${_habsList[index].pubDate}'))),
                                FloatingActionButton.extended(
                                  heroTag: null,
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ReadScreen(urlHab: '${_habsList[index].guid}',))),
                                  label: Text('Read'),
                                  icon: Icon(Icons.arrow_forward),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }

  _getAppBarIcon() {
    if (_darkTheme) {
      return Icons.highlight;
    } else {
      return Icons.lightbulb_outline;
    }
  }

  _getPlatformSwitch() {
    if (io.Platform.isIOS) {
      return CupertinoSwitch(
          value: _darkTheme,
          onChanged: (bool value) {
            setState(() {
              _darkTheme = !_darkTheme;
            });
          });
    } else if (io.Platform.isAndroid) {
      return Switch(
        value: _darkTheme,
        onChanged: (bool value) {
          setState(() {
            _darkTheme = !_darkTheme;
          });
        },
      );
    }
  }

  _getHttpHabs() async {
    var response = await fetchHttpHabs('https://habr.com/ru/rss/hubs/all/');
    var chanel = RssFeed.parse(response.body);
    chanel.items!.forEach((element) {
      _habsList.add(element);
    });

    return _habsList;
  }
}
