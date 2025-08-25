import 'package:dusty_dust/model/stat_model.dart';
import 'package:dusty_dust/utils/status_utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

import '../const/colors.dart';

class HourlyStat extends StatelessWidget {
  final Color darkColor;
  final Color lightColor;
  final Region region;
  const HourlyStat({
    required this.region,
    required this.darkColor,
    required this.lightColor,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ItemCode.values
          .map(
            (e) => FutureBuilder(
              future: GetIt.I<Isar>().statModels
                  .filter()
                  .regionEqualTo(region)
                  .itemCodeEqualTo(e)
                  .sortByDateTimeDesc()
                  .limit(24)
                  .findAll(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.hasError.toString()));
                }
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                final stats = snapshot.data!;

                return SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      color: lightColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: darkColor,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(16.0),
                                topLeft: Radius.circular(16.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Text(
                                e.krName,
                                textAlign: TextAlign.center,
                                style: TextTheme.of(context).displaySmall!
                                    .copyWith(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                              ),
                            ),
                          ),
                          ...stats
                              .map(
                                (stat) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 4.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${stat.dateTime.hour.toString().padLeft(2, '0')}시',
                                        ),
                                      ),
                                      Expanded(
                                        child: Image.asset(
                                          StatusUtils.getStatusModelFromStat(statModel: stat).iamgePath,
                                          height: 20.0,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          StatusUtils.getStatusModelFromStat(statModel: stat).lable,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
          .toList(),
    );
  }
}
