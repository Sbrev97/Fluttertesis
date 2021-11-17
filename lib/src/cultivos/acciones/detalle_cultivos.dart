import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tesisv2/src/cultivos/acciones/conectar_placa.dart';
import 'package:flutter_tesisv2/src/cultivos/acciones/editar_cultivo.dart';
import 'package:flutter_tesisv2/src/cultivos/cultivos.dart';
import 'package:flutter_tesisv2/src/cultivos/sensor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class DetalleCultivo extends StatefulWidget {
  final int indexCult;

  final List listaCult;

  const DetalleCultivo({Key key, this.indexCult, this.listaCult})
      : super(key: key);

  @override
  _DetalleCultivoState createState() => _DetalleCultivoState();
}

class _DetalleCultivoState extends State<DetalleCultivo> {
  bool verificarsi = false;
  bool verificado = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed("cultivos");
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              var url = "http://192.168.1.81/pruebastesis/EliminarCultivo.php";
              await http.post(Uri.parse(url), body: {
                "Cultivo_id": widget.listaCult[widget.indexCult]['Cultivo_id']
              });
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Cultivo()));
            },
          ),
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(context, "editarcultivo",
                    arguments: widget.listaCult[widget.indexCult]
                        ['Cultivo_id']);
              }),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Navigator.pushNamed(context, "publicacion",
                  arguments: widget.listaCult[widget.indexCult]['Cultivo_id']);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.listaCult[widget.indexCult]['Cultivo_apodo'],
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Container(
                  height: 250,
                  child: FadeInImage(
                    image: NetworkImage(
                        widget.listaCult[widget.indexCult]['Cultivo_imagen']),
                    placeholder: AssetImage('assets/jar-loading.gif'),
                  )),
              Divider(),
              Divider(),
              Visibility(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("adquiriste nuestro producto(?)"),
                        ElevatedButton(
                            onPressed: () {
                              verificarsi = true;
                              verificado = false;
                              setState(() {});
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => Placa(),
                                ),
                              );
                            },
                            child: Text("si")),
                        ElevatedButton(
                            onPressed: () {
                              verificarsi = false;
                              verificado = false;
                              setState(() {});
                            },
                            child: Text("no")),
                      ],
                    ),
                  ),
                  visible: verificado),
              Visibility(
                child: Container(
                  child: ListBody(
                    children: [
                      Divider(),
                      ListTile(
                        leading: Icon(FontAwesomeIcons.thermometerQuarter),
                        title: Text('Sensor de temperatura'),
                        subtitle: Text('28ºC'),
                        trailing: Switch(
                          onChanged: (value) => print('toggle sensor'),
                          activeColor: Colors.green,
                          value: true,
                        ),
                        onTap: () => Navigator.pushNamed(context, "temperatura",
                            arguments: widget.listaCult[widget.indexCult]
                                ['Cultivo_id']),
                      ),
                      ListTile(
                        leading: Icon(FontAwesomeIcons.tint),
                        title: Text('Sensor de humedad'),
                        subtitle: Text('45%'),
                        trailing: Switch(
                          onChanged: (value) => print('toggle sensor'),
                          activeColor: Colors.green,
                          value: true,
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Sensor(
                              nombre: 'humedad',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                visible: verificarsi,
              ),
            ],
          ),
        ),
      ),
    );
  }

  eliminarCultivo() async {
    String cultivoid = widget.listaCult[widget.indexCult]['Cultivo_id'];
    var url =
        'http://192.168.1.81/pruebastesis/EliminarCultivo.php?Cultivo_id=$cultivoid';
    var response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }
}