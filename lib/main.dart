import 'package:dusty_dust/model/stat_model.dart';
import 'package:dusty_dust/screen/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [StatModelSchema],
    directory: dir.path,
  );
  GetIt.I.registerSingleton<Isar>(isar);
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
