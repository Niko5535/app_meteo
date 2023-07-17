import 'dart:convert';
import 'package:app_meteo/models/result_meteo.dart';
import 'package:flutter/cupertino.dart';
import 'package:app_meteo/env.dart';
import 'package:http/http.dart' as http;

class HttpMeteo {
  Duration get loginTime => const Duration(milliseconds: 0);
  Future<ResultMeteo?> getMeteo(String latitudine, String longitudine) async {
    return Future.delayed(loginTime).then((_) async {
      final response = await http.get(Uri.parse(
          '$base_url/forecast?latitude=$latitudine&longitude=$longitudine&hourly=temperature_2m,weathercode&forecast_days=1'));
      if (response.statusCode == 200) {
        ResultMeteo resultMeteo =
            ResultMeteo.fromJson(jsonDecode(response.body));
        return resultMeteo;
      } else {
        debugPrint('Errore ${response.statusCode}: ${response.body}');
        return null;
      }
    });
  }
}
