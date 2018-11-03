import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class idMesa extends StatefulWidget {
  @override
  _MesaPageState createState() => new _MesaPageState();
}

class _MesaPageState extends State<idMesa> {
  final String url =
      "http://elecciones-sa.tk:8080/elecciones/rest/mesas-votacion";
  List data;
  @override
  void initState() {
    super.initState();
    this.getJsonData();
  }

  Future<String> getJsonData() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"accept": "application/json"});

    print(response.body);
    setState(() {
      var converDataToJson = json.decode(response.body);
      data = converDataToJson;
    });
    return "success";
  }

  String inputstr = "";
  bool expanded = false;
  int n = 0;
  var nuevo = Text("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar Mesa'),
      ),
      body: new Container(
        child: Column(children: <Widget>[
          Center(
            child: new TextField(
              onChanged: (String textinput) {
                setState(() {
                  inputstr = textinput;
                  print(inputstr);
                });
              },
            ),
          ),

          Divider(),
          new RaisedButton(
            child: new Text('Buscar Resultado de Mesa'),
            onPressed: (){
              nuevo = Text("");
              if (inputstr!=""){
                for (int it = 0; it <=data.length; it++){
                  if(data[it]['numMesa'].toString()==inputstr){
                    n = it;
                      nuevo = Text('No.Mesa: ' +
                          data[n]['numMesa'].toString() +
                          ' Cantidad de votos: \n Nulos: ' +
                          data[n]['cantNulos'].toString() +
                          ' Blancos: ' +
                          data[n]['cantBlancos'].toString());

                  }
                }
              }
            } ,
          ),
          Divider(
            height: 10.0,
          ),
          new ExpansionPanelList(
            expansionCallback: (i, bool val){
              setState(() {
                expanded = !val;

              });
            },
            children: [
              new ExpansionPanel(
                body: new Container(
                  padding: EdgeInsets.all(20.0),
                  child: ListTile(
                    title: nuevo,
                  ),
                ),
                headerBuilder: (BuildContext context, bool val){
                  return new Center(
                    child: new Text('Visualizar Datos',
                      style: new TextStyle(fontSize: 18.0),),
                  );
                },
                isExpanded: expanded,
              )
            ],
          ),

          Divider(),
          nuevo,

        ]),
      ),
    );

    /*return new Scaffold(
      appBar: new AppBar(
        title: new Text('Consulta todas las Mesas'),
      ),

    );*/
  }
}
