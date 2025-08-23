import 'package:dusty_dust/component/Hourly_stat.dart';
import 'package:dusty_dust/component/categorystat.dart';
import 'package:dusty_dust/component/main_stat.dart';
import 'package:dusty_dust/const/colors.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                MainStat(),
                Categorystat(),
                HourlyStat(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
