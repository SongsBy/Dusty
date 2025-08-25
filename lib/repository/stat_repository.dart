import 'package:dio/dio.dart';
import 'package:dusty_dust/model/stat_model.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

class StatRepository {
  static Future<void>fetchData()async{

  final isar = GetIt.I<Isar>();
  final now = DateTime.now();
  final compareDateTimeTarget = DateTime(
    now.year,
    now.month,
    now.day,
    now.hour,
  );

  final count = await isar.statModels
      .filter()
      .dateTimeEqualTo(compareDateTimeTarget)
      .count();

  if(count > 0){
    print('데이터가 존재합니다 : count: ${count}');
    return;
  }

    for (ItemCode itemCode in ItemCode.values){
      await fetchDataByItemCode(itemCode: itemCode);
    }
  }
  static Future<List<StatModel>> fetchDataByItemCode(
      {required ItemCode itemCode
      }) async {
    final itemCodeStr = itemCode == ItemCode.PM25 ? 'PM2.5' : itemCode.name;
  final response = await Dio().get(
    'http://apis.data.go.kr/B552584/ArpltnStatsSvc/getCtprvnMesureLIst',
    queryParameters: {
      'serviceKey':
      'bc1148c6e851a01d0fa8c07d73913b5aca6a926de2de4a676d48ff267544b64a',
      'returnType': 'json',
      'numOfRows': '100',
      'pageNo': '1',
      'itemCode': itemCodeStr,
      'dataGubun': 'HOUR',
      'searchCondition': 'WEEK',
    },
  );

  if (response.data['response']?['body']?['items'] == null) {
    return [];
  }

  final rawItemList = response.data['response']['body']['items'] as List;
  final List<StatModel> stats = [];
  final isar = GetIt.I<Isar>();

  final List<String> skipKeys = [
    'dataGubun',
    'dataTime',
    'itemCode',
  ];

  for (Map<String, dynamic> item in rawItemList) {

    try {
      // [수정 2] 올바른 키 'dataTime' 사용
      final dateTime = DateTime.parse(item['dataTime']);

      for (String key in item.keys) {
        if (skipKeys.contains(key)) {
          continue;
        }

        final regionStr = key;
        final value = item[regionStr];

        double statValue;
        if (value is int) {
          statValue = value.toDouble();
        } else if (value is String) {
          final parsed = double.tryParse(value);
          if (parsed == null) continue;
          statValue = parsed;
        } else {
          continue;
        }

        final region = Region.values.firstWhere((e) => e.name == regionStr);

        final statModel = StatModel()
          ..region = region
          ..stat = statValue
          ..dateTime = dateTime
          ..itemCode = itemCode;

       final count= await isar.statModels.filter()
        .regionEqualTo(region)
        .dateTimeEqualTo(dateTime)
        .itemCodeEqualTo(itemCode)
        .count();

       if(count > 0){
         continue;
       }
        await isar.writeTxn(
              () async {
            await isar.statModels.put(statModel);
          },
        );
        stats.add(statModel);
      }
    } catch (e){

      print('데이터 처리 중 에러 발생: $item, 에러: $e');
      continue;
    }
  }
  return stats;
}
}
