import 'package:app_meteo/models/result_meteo.dart';
import 'package:app_meteo/services/http_request.dart';
import 'package:app_meteo/widgets/language_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const route = "/home";
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<bool> isSelected = <bool>[true, false];
  ResultMeteo? dati;
  bool vertical = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initGeoLocator();
  }

  initGeoLocator() async {
    isLoading = true;
    setState(() {});
    bool servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          print("GPS Location service is granted");
        }
      } else {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        getDatiMeteo(
            position.latitude.toString(), position.longitude.toString());
      }
    }
  }

  getDatiMeteo(String latitudine, String longitudine) async {
    HttpMeteo httpCheckin = HttpMeteo();
    ResultMeteo? response = await httpCheckin.getMeteo(latitudine, longitudine);
    dati = response;
    isLoading = false;
    setState(() {});
  }

  aggiornaStato() {
    setState(() {});
  }

  DateTime getDateTime(String data) {
    return DateFormat("yyyy-MM-ddThh:mm").parse(data);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        listaOrari(),
        Visibility(visible: isLoading, child: loading())
      ],
    );
  }

  Widget loading() {
    return Container(
      color: Colors.black12,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget listaOrari() {
    String locale = Localizations.localeOf(context).languageCode;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 0, 26, 71),
                Colors.deepPurple,
                Colors.black
              ]),
        ),
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                      size: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        DateFormat.yMMMMEEEEd(locale)
                            .format(DateTime.now())
                            .toTitleCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontFamily: 'Georgia'),
                      ),
                    ),
                    LanguagePickerWidget(
                      aggiornaStato: aggiornaStato,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: dati?.hourly?.temperature2m?.length,
                  itemBuilder: (BuildContext context, int index) =>
                      _buildList(dati?.hourly?.time?[index], index, context),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }

  Widget _buildList(String? item, int index, BuildContext context) {
    String img = "";
    String text = "";
    switch (dati?.hourly?.weathercode?[index]) {
      case 0:
        text = AppLocalizations.of(context)!.soleggiato;
        img = "assets/weather/sun.png";
        break;
      case 1:
      case 2:
      case 3:
        text = AppLocalizations.of(context)!.nuvoloso;
        img = "assets/weather/cloudy.png";
        break;
      default:
        text = AppLocalizations.of(context)!.pioggia;
        img = "assets/weather/storm.png";
        break;
    }

    if (item != null) {
      return Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 10, right: 10, bottom: 20),
              child: Column(
                children: [
                  ListTile(
                    leading: Text(
                      DateFormat('HH:mm').format(getDateTime(item)),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Georgia',
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Row(
                        children: [
                          SizedBox(height: 16, child: Image.asset(img)),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              text,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Georgia',
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    trailing: Text(
                      "${dati!.hourly!.temperature2m![index].toStringAsFixed(0)}°",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ),
                ],
              )),
          const Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Divider(
              height: 1,
              color: Colors.white24,
            ),
          )
        ],
      );
    } else {
      return const Text("");
    }
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
