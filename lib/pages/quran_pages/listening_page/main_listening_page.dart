import 'package:althaqafy/constants.dart';
import 'package:althaqafy/pages/quran_pages/listening_page/mugawwad_page.dart';
import 'package:althaqafy/pages/quran_pages/listening_page/sho3ba_page.dart';
import 'package:althaqafy/pages/quran_pages/listening_page/warsh_page.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_style.dart';
import '../../../widgets/listening_button.dart';
import 'favorite_page.dart';
import 'murattal_page.dart';

class ListeningPage extends StatelessWidget {
  const ListeningPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> buttonData = [
      {'text': 'المفضلة', 'page': const FavoritePage()},
      {'text': 'القرآن المرتل', 'page': const MurattalPage()},
      {'text': 'القرآن المجود', 'page': const MugawwadPage()},
      {'text': 'رواية ورش', 'page': const WarshPage()},
      {'text': 'رواية شعبة', 'page': const Sho3baPage()},
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove back button
        iconTheme: IconThemeData(
          color: AppStyles.styleDiodrumArabicbold20(context).color,
        ),
        centerTitle: true,
        title: Text(
          'القران المسموع',
          style: AppStyles.styleDiodrumArabicbold20(context),
        ),
        backgroundColor: AppColors.kSecondaryColor,
      ),
      backgroundColor: AppColors.kPrimaryColor,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 items per row
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 1.0, // Square aspect ratio
          ),
          itemCount: buttonData.length,
          itemBuilder: (context, index) {
            return ListeningButtons(
              buttonText: buttonData[index]['text'],
              builder: (context) => buttonData[index]['page'],
            );
          },
        ),
      ),
    );
  }
}
