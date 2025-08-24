import 'package:dusty_dust/component/Hourly_stat.dart';
import 'package:dusty_dust/component/categorystat.dart';
import 'package:dusty_dust/component/main_stat.dart';
import 'package:dusty_dust/const/colors.dart';
import 'package:dusty_dust/model/stat_model.dart';
import 'package:dusty_dust/repository/stat_repository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {

  @override
  void initState() {
    super.initState();


    StatRepository.fetchData(itemCode: ItemCode.PM10);
    getCount();
  }

  getCount()async{
    print(await GetIt.I<Isar>().statModels.count());
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: FutureBuilder<List<StatModel>>(
              future: StatRepository.fetchData(
                itemCode: ItemCode.PM10,
              ),
              builder: (context , snapshot) {
                print(snapshot.data);
                print(snapshot.error);
                print(snapshot.stackTrace);
                if(snapshot.hasData) {
                  // print(snapshot.data!['response']['body']['totalCount']);
                }
                return Column(
                  children: [
                    MainStat(),
                    Categorystat(),
                    HourlyStat(),
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}
