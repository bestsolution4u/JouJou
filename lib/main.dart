import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:joujou_lounge/screen/home_screen.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) {
    SystemChrome.setEnabledSystemUIOverlays([])
        .then((value) => runApp(EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('ar', 'DZ')],
        path: 'assets/translations',
        fallbackLocale: Locale('en', 'US'),
        child: JouJouApp()
    ),));
  });
}

class JouJouApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print(context.supportedLocales[0].languageCode);
    return MaterialApp(
      title: 'JouJou Lounge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.supportedLocales[0],
      home: HomeScreen(),
    );
  }
}
