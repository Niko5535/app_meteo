import 'package:app_meteo/pages/home.dart';
import 'package:app_meteo/provider/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      builder: (context, child) {
        final provider = Provider.of<LocaleProvider>(context);
        return MaterialApp(
          initialRoute: "/",
          onGenerateRoute: (settings) {
            final routes = {
              HomePage.route: (context) => const HomePage(),
            };
            return MaterialPageRoute(builder: routes[settings.name]!);
          },
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: provider.locale,
          supportedLocales: const [
            Locale('en', ''),
            Locale('it', ''),
          ],
          theme: ThemeData(
            fontFamily: 'Georgia',
          ),
          home: const HomePage(),
        );
      });
}
