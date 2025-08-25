import 'package:dusty_dust/const/status_level.dart';
import 'package:dusty_dust/model/stat_model.dart';
import 'package:dusty_dust/utils/date_utils.dart';
import 'package:dusty_dust/utils/status_utils.dart';
import 'package:flutter/material.dart' hide DateUtils;
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

class MainStat extends StatefulWidget {
  final Color primaryColor;
  final Region region;
  final bool isExpanded;
  const MainStat({
    required this.region,
    required this.primaryColor,
    required this.isExpanded,
    super.key
  });

  @override
  State<MainStat> createState() => _MainStatState();
}

class _MainStatState extends State<MainStat> {
  // 2. Future를 저장할 상태 변수 선언
  late Future<StatModel?> statFuture;

  @override
  void initState() {
    super.initState();
    statFuture = fetchData();
  }


  @override
  void didUpdateWidget(covariant MainStat oldWidget) {
    super.didUpdateWidget(oldWidget);

    if(oldWidget.region != widget.region){
      setState(() {
        statFuture = fetchData();
      });
    }
  }


  Future<StatModel?> fetchData() {
    return GetIt.I<Isar>()
        .statModels.filter()
        .regionEqualTo(widget.region)
        .itemCodeEqualTo(ItemCode.PM10)
        .sortByDateTimeDesc()
        .findFirst();
  }

  @override
  Widget build(BuildContext context) {
    final LargeText = Theme.of(context).textTheme.displayLarge;
    final SmallText = Theme.of(context).textTheme.displaySmall;

    return SliverAppBar(
      backgroundColor: widget.primaryColor,
      expandedHeight: 500,
      pinned: true,
      title: widget.isExpanded ? null : Text('${widget.region.krName}'),
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: FutureBuilder<StatModel?>(
                future: statFuture,
                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: Colors.white));
                  }
                  if (snapshot.data == null) {
                    return Center(
                      child: Text(
                        '데이터가 없습니다',
                        style: LargeText?.copyWith(color: Colors.white),
                      ),
                    );
                  }

                  final statModel = snapshot.data!;
                  final status = StatusUtils.getStatusModelFromStat(statModel: statModel);


                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: kToolbarHeight,),
                      Text(
                        widget.region.krName,
                        style: LargeText?.copyWith(
                            color: Colors.white, fontSize: 40),
                      ),
                      Text(
                          DateUtils.DateTimeToString(dateTIme: statModel.dateTime),
                          style: SmallText?.copyWith(
                              color: Colors.white)
                      ),
                      SizedBox(height: 20),
                      Image.asset(
                        status.iamgePath,
                        width: MediaQuery.of(context).size.width / 2,
                      ),
                      SizedBox(height: 20),
                      Text(
                          status.lable, style:
                      LargeText?.copyWith(
                          color: Colors.white,
                          fontSize: 40)
                      ),
                      SizedBox(height: 20),
                      Text(
                          status.comment,
                          style: SmallText?.copyWith(
                              color: Colors.white)
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}