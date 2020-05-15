import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'myStyle.dart';
import 'package:path_provider/path_provider.dart';

// Stateful pois a tela será modificada
// poderemos interagir com a tela
void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String dogName = "";
  int nameDog =
      0; // utilizado como flag para verificar se o nome foi cadastrado.

  TextEditingController nomeDog = TextEditingController();
  TextEditingController heightController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _infoText = "Informe seus dados";

  void _resetFields() {
    nomeDog.text = "";
    nameDog = 0;
    setState(() {
      excluirNome();
      _infoText = "Informe seus dados";
    });
  }

  verifyNome(BuildContext context) async {
    String text;
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = File('${directory.path}/nomeDog.txt');

      text = await path.readAsString();
      dogName = text;
      setState(() {
        nameDog = 1;
      });
      
    } catch (e) {
      print("Error" + e.toString());
    }
  }

  TextFormField inserirNomeDog() {
    // TextFormField - para formulário
    // TextFormField possui um parâmetro validator
    // para verificar se o campo está preenchido
    TextFormField field = new TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: "Digite o nome do seu dog:",
          labelStyle: TextStyle(color: Style.padrao) // mudar a cor do campo
          ),
      textAlign: TextAlign.center,
      style: TextStyle(color: Style.padrao, fontSize: 25.0),
      controller: nomeDog, // Variável que irá receber o dado
      validator: (value) {
        if (value.isEmpty) {
          return "Insira um nome!";
        }
      },
    );

    return field;
  }

  Padding botaoGravarNome() {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Container(
          // Utilizado um Container para deixar o botão maior
          height: 50.0,
          child: RaisedButton(
            onPressed: () {
              print("AAAAA");
              if (_formKey.currentState.validate()) {
                setState(() {
                  dogName = nomeDog.toString();
                  print("DOG NAME: " + dogName);
                  gravarNome(nomeDog.text);
                  print("nomeDog: " + nomeDog.toString());
                });
              }
            },
            child: Text("Gravar nome",
                style: TextStyle(color: Colors.white, fontSize: 25.0)),
            color: Style.padrao,
          )),
    );
  }

  Column columnGravarNome() {
    return Column(
      children: <Widget>[
        TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelText: "Digite o nome do seu dog:",
              labelStyle: TextStyle(color: Style.padrao) // mudar a cor do campo
              ),
          textAlign: TextAlign.center,
          style: TextStyle(color: Style.padrao, fontSize: 25.0),
          controller: nomeDog, // Variável que irá receber o dado
          validator: (value) {
            if (value.isEmpty) {
              return "Insira um nome!";
            }
          },
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Container(
              // Utilizado um Container para deixar o botão maior
              height: 50.0,
              child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      dogName = nomeDog.text;
                      gravarNome(nomeDog.text);
                    });
                  }
                },
                child: Text("Gravar nome",
                    style: TextStyle(color: Colors.white, fontSize: 25.0)),
                color: Style.padrao,
              )),
        ),
      ],
    );
  }

  gravarNome(String nomeDog) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = File('${directory.path}/nomeDog.txt');
    await path.writeAsString(nomeDog);
    nameDog = 1;
  }

  excluirNome() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = File('${directory.path}/nomeDog.txt');
    path.delete();
    nameDog = 0;
  }


  @override
  void initState(){
    super.initState();
    verifyNome(context);
  }

  @override
  Widget build(BuildContext context)  {
    verifyNome(context);
    return Scaffold(
      appBar: AppBar(
        // Barra superior
        title: Text("Controle DOG"),
        centerTitle: true,
        backgroundColor: Style.padrao,
        // Quando queremos colocar algum botao na barra
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: _resetFields),
        ],
      ),
      backgroundColor: Colors.amber[50],
      // SingleChildScrollView - utilizado para a página "rolar"
      // caso contrário iria ficar amarelo e preto
      body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Form(
            // Utilizado para formulário
            key: _formKey,
            child: Column(
              // crossAxisAlignment:Tenta alargar todo o espaço da largura
              // da página
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(Icons.pets, size: 120.0, color: Style.padrao),
                if (nameDog == 0)
                  columnGravarNome(), // Caso nome não foi gravado
                if (nameDog == 1)
                  Text("DOG CADASTRADO: " + 
                    dogName,
                    style: Style.texto,
                  ),
              ],
            ),
          ),
        )
    );
  }
}
