import 'dart:async';
import 'dart:convert';

import './mesa.dart';
import './idmesa.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main()=> runApp(MaterialApp(
  home: HomePage(),
  //elimina la banda de bug
  debugShowCheckedModeBanner: false,
));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>{
  final String url = "http://elecciones-sa.tk:8080/elecciones/rest/electores";
  List data;
  @override
  void initState(){
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
  String inputstr = "";
  bool expanded = false;
  int n = 0;
  String nuevo = "";
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text('Lista de electores'),
      ),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: Text('App de Votaciones'),
                accountEmail: Text('Guatemalausac@gmail.com'),
        currentAccountPicture: new CircleAvatar(
          backgroundImage: new NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/4/4a/Usac_logo.png/250px-Usac_logo.png'),
        ),
        ),
            new ListTile(
              title: Text('Consultar todas las mesas'),
              onTap: (){
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context)=> new Mesa())
                );
              }
            ),
            new Divider(),
            new ListTile(
                title: Text('Consultar una mesa especifica'),
                onTap: (){
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context)=> new idMesa())
                  );
                }
            ),
            new ListTile(
                title: Text('Otro'),
                onTap: (){
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context)=> new idMesa())
                  );
                }
            )
    ],
      ),
      ),
      body: new Container(
        child: Column(
          children: <Widget>[
            Center(
              child: new TextField(
                onChanged: (String textinput){
                  setState(() {
                    inputstr =  textinput;
                    print(inputstr);
                  });
                },
              ),
            ),
            Divider(),
            new Text(inputstr),
            Divider(),
            new RaisedButton(
              child: new Text('Buscar Persona'),
              onPressed: (){
                nuevo = "";
                if (inputstr!=""){
                  for (int it = 0; it <=data.length; it++){
                    if(data[it]['dpi'].toString()==inputstr){
                      nuevo = 'DPI: '+data[it]['dpi'].toString()+'  No.de Patron: '+data[it]['numPadron'].toString()+'\n'+
                'Nombre: '+data[it]['nombres']+' '+data[it]['apellidos']+'\n'+'Direccion: '+data[it]['direccion']+' '+data[it]['extraDireccion'].toString()+
                '\n'+'Emision de voto: '+data[it]['votoEmitido'].toString();
                      print (nuevo);
                    }
                  }
                }
              } ,
            ),
            Divider(),
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
                    child: Text(nuevo),
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

          ],
        ),
      ),


    );
  }

}

void _search(List data, String id){




}


