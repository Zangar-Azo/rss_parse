import 'package:flutter/material.dart';
import 'package:rss_parse/model/hab_model.dart';
import 'package:rss_parse/common/fetch_http_habs.dart';
import 'package:html/parser.dart  ';

class ReadScreen extends StatefulWidget {
  final urlHab;

  const ReadScreen({Key? key, this.urlHab}) : super(key: key);

  @override
  _ReadScreenState createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  var _habModel = Hab(body: 'body', title: 'title', hab_url: 'hab_url');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: _getHab()
      ),
    );
  }

  _getHab () {
    return FutureBuilder(
        future: null,
        builder: (context, AsyncSnapshot snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView();
        }
    });
  }

  // _getHttpHab() async{
  //     var response = await fetchHttpHabs(widget.urlHab);
  //     var _hab = parse(response.body);
  //     print(_hab.getElementsByClassName('post_'));
  // }
}
