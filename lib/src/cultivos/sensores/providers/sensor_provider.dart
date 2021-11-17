import 'dart:convert';

import 'package:flutter_tesisv2/src/cultivos/sensores/models/sensor_model.dart';
import 'package:http/http.dart' as http;

class SensorProvider {
  final String _url = "https://lefufudb-default-rtdb.firebaseio.com";

  Future<bool> asignarDatos(SensorModel sensor) async {
    final url = "$_url/Sensor.json";

    final resp =
        await http.post(Uri.parse(url), body: sensorModelToJson(sensor));

    final decodedData = jsonDecode(resp.body);

    print(decodedData);

    return true;
  }
}