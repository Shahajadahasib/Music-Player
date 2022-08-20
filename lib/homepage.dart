// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 350,
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: NetworkImage(
                      'https://img.freepik.com/free-photo/asian-man-wearing-headphones-listening-music-moving-body_8087-2847.jpg?w=2000')),
              color: Colors.red,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.elliptical(160.0, 170.0),
                bottomRight: Radius.elliptical(160.0, 170.0),
              ),
            ),
            child: Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.black,
                )),
          ),
        ],
      ),
    );
  }
}
