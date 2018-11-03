import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Mesa extends StatefulWidget{
 @override
 _MesaPageState createState()=> new _MesaPageState();

}

class _MesaPageState extends State<Mesa>{
  final String url = "http://elecciones-sa.tk:8080/elecciones/rest/mesas-votacion";
  List data;
  @override
  void initState() {
    super.initState();
    this.getJsonData();
  }

  Future<String> getJsonData() async{
    var response = await http.get(
        Uri.encodeFull(url),
        headers: {"accept":"application/json"}
    );

    print(response.body);
    setState(() {
      var converDataToJson = json.decode(response.body);
      data = converDataToJson;
    });
    return "success";
  }

    @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Consultar todas las mesas'),
        ),
        body: ListView.builder(
          itemCount: data == null ? 0: data.length,
          itemBuilder: (BuildContext context, int index){
            return Container(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Card(
                      child: Container(

                        child: Text('No.Mesa: '+data[index]['numMesa'].toString()+' Cantidad de votos: \n Nulos: '+
                        data[index]['cantNulos'].toString()+' Blancos: '+data[index]['cantBlancos'].toString()),
                        padding: const EdgeInsets.all(20.0),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );

    /*return new Scaffold(
      appBar: new AppBar(
        title: new Text('Consulta todas las Mesas'),
      ),

    );*/
  }


}
