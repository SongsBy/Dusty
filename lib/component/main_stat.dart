import 'package:flutter/material.dart';

class MainStat extends StatelessWidget {
  const MainStat({super.key});

  @override
  Widget build(BuildContext context) {
    final LargeText = TextTheme.of(context).displayLarge;
    final MediumText = TextTheme.of(context).displayMedium;
    final SmallText = TextTheme.of(context).displaySmall;
    return Column(
      children: [
        Text('서울', style: LargeText?.copyWith(color: Colors.white)),

        Text(
          '2024-4-1 11:00',
          style: SmallText?.copyWith(color: Colors.white),
        ),
        SizedBox(height: 20),
        Image.asset(
          'assets/img/mediocre.png',
          width: MediaQuery.of(context).size.width / 2,
        ),
        SizedBox(height: 20),
        Text('보통', style: LargeText?.copyWith(color: Colors.white)),

        Text(
          '나쁘지 않네요!',
          style: SmallText?.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
