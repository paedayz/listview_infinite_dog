import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List dogImages = [];
  ScrollController _scrollcontroller = ScrollController();
  int firstRowDogImage = 0;
  List<Widget> homeList = [
    Row(
      children: [
        Text(
          'Row 1',
          style: TextStyle(fontSize: 20),
        ),
      ],
    ),
    Row(
      children: [
        Text(
          'Row 1',
          style: TextStyle(fontSize: 20),
        ),
      ],
    ),
    SizedBox(
      height: 20,
    )
  ];

  @override
  void initState() {
    fetchFour();

    _scrollcontroller.addListener(() {
      if (_scrollcontroller.position.pixels ==
          _scrollcontroller.position.maxScrollExtent) {
        fetchFour();
      }
    });
    super.initState();
  }

  Widget dogTile(image) {
    return Container(
      height: 150,
      width: 190,
      child: Image.network(image, fit: BoxFit.cover),
    );
  }

  Widget rowDog(firstData, secondData) {
    return Row(
      children: [
        dogTile(firstData),
        secondData != null ? dogTile(secondData) : Container(),
      ],
    );
  }

  bool isEven(int val) {
    return (val & 0x01) == 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: ListView.builder(
              controller: _scrollcontroller,
              itemCount: (dogImages.length / 2).ceil() + homeList.length,
              itemBuilder: (context, index) {
                int maxLength = (dogImages.length / 2).ceil() + homeList.length;
                int fDogindex = (index - homeList.length) * 2;

                if (index < homeList.length) {
                  return homeList[index];
                } else if (isEven(dogImages.length) && index == maxLength) {
                  return rowDog(dogImages[fDogindex], null);
                } else {
                  return rowDog(
                    dogImages[fDogindex],
                    dogImages[(fDogindex) + 1],
                  );
                }
              })),
    );
  }

  fetch() async {
    final res = await get(Uri.parse('https://dog.ceo/api/breeds/image/random'));
    if (res.statusCode == 200) {
      setState(() {
        dogImages.add(json.decode(res.body)['message']);
      });
    } else {
      throw Exception('Failed to load images');
    }
  }

  fetchFour() {
    for (var i = 0; i < 10; i++) {
      fetch();
    }
  }

  floor(double d) {}
}
