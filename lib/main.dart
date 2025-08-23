import 'package:dusty_dust/screen/homescreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homescreen(),
      theme: ThemeData(
        fontFamily: 'sunflower',
        textTheme: TextTheme(
          displayLarge: TextStyle(
              fontSize: 40.0
          ),
          displayMedium: TextStyle(
            fontSize: 30.0
          ),
          displaySmall: TextStyle(
            fontSize: 20.0
          )
        ),
      ),
    )
  );
}
