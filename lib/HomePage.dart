import 'dart:async';
import 'dart:convert' show json;

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/DetailNews.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {

  final String url;

  const HomePage({Key key, this.url}) : super(key: key);

  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {

  List data;
  final Set<List> _saved = new Set<List>();

  Future<String> getData() async {
    try {
      var response = await http.get(widget.url);
      this.setState(() {
        Map decoded = json.decode(response.body);
        data = decoded['articles'];
      });
      return "Success!";
    }
    catch (e) {
      return "No Internet";
      //return new SnackBar(content: new Text("No Internet Connectivity"),duration: ,new Duration(seconds: 5));
    }
  }

  bool isInternetConnectivity() {
    var connectivityResult = new Connectivity()
        .checkConnectivity(); // User defined class
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    final bool alreadySaved = _saved.contains(String);
    return new Scaffold(
        body: new Container(child: new ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: data == null ? 0 : data.length,
          itemBuilder: (BuildContext context, int index) {
            return new Card(
                margin: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                elevation: 4.0,
                child: new Column(
                    children: <Widget>[
                      new Container(
                        padding: new EdgeInsets.only(
                            left: 16.0, right: 16.0, bottom: 8.0),
                        child: new InkWell(
                          onTap: () =>
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    DetailNews(data[index]["url"])),
                              ),
                          child: new Wrap(
                            spacing: 8.0,
                            // gap between adjacent chips
                            runSpacing: 4.0,
                            // gap between lines
                            direction: Axis.horizontal,
                            // main axis (rows or columns)

                            children: <Widget>[
                              new Container(
                                  height: 16.0),


                              data[index]["source"]["name"] == null
                                  ? new Text("")
                                  : new Container(
                                  height: 20.0,
                                  child: new Text(data[index]["source"]["name"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic),
                                      textAlign: TextAlign.center)),

                              data[index]["urlToImage"] == null
                                  ? new Image.network(
                                  " https://static01.nyt.com/images/2018/09/08/business/08dc-trade/08dc-trade-facebookJumbo.jpg")
                                  : new Image.network(
                                  data[index]["urlToImage"], fit: BoxFit.cover),
                              new Container(
                                height: 20.0,
                              ),

                              data[index]["title"] == null
                                  ? new Text("Missing Title")
                                  : new Container(
                                  height: 60.0,
                                  child: new Text(data[index]["title"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 16.0
                                      ),
                                      textAlign: TextAlign.center)),

                              data[index]["description"] == null
                                  ? new Text("")
                                  : new Container(
                                  height: 100.0,
                                  child: new Text(data[index]["description"],
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic))),

                            ],

                          ),

                        ),
                      ),
                      new Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              new Icon(Icons.share),
                              new GestureDetector(
                                  child: new Icon(
                                    alreadySaved ? Icons.favorite : Icons
                                        .favorite_border,
                                    color: alreadySaved ? Colors.red : null,),
                                  onTap: () {
                                    setState(() {
                                      if (alreadySaved) {
                                        _saved.remove(data[index]);
                                      } else {
                                        _saved.add(data[index]);
                                      }
                                    }
                                    );
                                  }
                              )
                            ]),
                      ),
                    ])
            );
          },

        ),
        )
    );
  }
}