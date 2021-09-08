import 'package:flutter/material.dart';
import 'package:rss_parse/screens/home_screens.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeScreenRSS();
  }
}

