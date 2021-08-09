import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:via_cep/LocationPage.dart';

class GetCep extends StatefulWidget {
  const GetCep({Key? key}) : super(key: key);

  @override
  _GetCep createState() => _GetCep();
}

class _GetCep extends State<GetCep> {
  final formKey = GlobalKey<FormState>();
  Map? currentLocation;
  bool isFavorite = false;
  List myLocations = <Map>[];
  late String cep;

  dropError(message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
      action: SnackBarAction(
        textColor: Colors.white,
        label: 'Close',
        onPressed: () {},
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('CepFinder'), Icon(Icons.map_outlined)],
        ),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            // Form
            Container(
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50))),
              child: Center(
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, bottom: 30, top: 30),
                  child: Form(
                      key: formKey,
                      child: Center(
                        child: Container(
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                  child: TextFormField(
                                validator: (value) {
                                  final RegExp exp =
                                      RegExp(r'^[0-9]{5}-?[0-9]{3}$');

                                  if (value == null || value.isEmpty) {
                                    dropError('Required Field!');

                                    return '';
                                  } else if (!exp.hasMatch(value)) {
                                    dropError('Invalid CEP!');

                                    return '';
                                  }

                                  setState(() => cep = value);

                                  return null;
                                },
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(height: 0),
                                  contentPadding: EdgeInsets.only(left: 30),
                                  hintText: 'Type a cep...',
                                  border: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                ),
                              )),
                              Flexible(
                                  flex: 0,
                                  child: TextButton(
                                    child: Icon(Icons.search_outlined),
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        final String baseURL =
                                            'https://viacep.com.br/ws/$cep/json';
                                        final Uri uri = Uri.parse(baseURL);

                                        final resp = await http.get(uri);
                                        final parsedData =
                                            json.decode(resp.body) as Map;

                                        if (parsedData['erro'] == true) {
                                          dropError('CEP was not found :(');
                                        } else {
                                          setState(() {
                                            currentLocation = parsedData;
                                            isFavorite = false;
                                          });
                                        }
                                      }
                                    },
                                  ))
                            ],
                          ),
                        ),
                      )),
                ),
              ),
            ),
            // Result
            if (currentLocation != null)
              Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 20),
                child: Card(
                  // elevation: 0,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(currentLocation!['cep']),
                        subtitle: Text(
                            '${currentLocation!['localidade']} - ${currentLocation!['uf']}'),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                if (!isFavorite){
                                  final hasElement = myLocations.where((l) =>
                                      l['cep'] == currentLocation!['cep']);

                                  if (hasElement.isEmpty) {
                                    setState(
                                        () {
                                          myLocations.add(currentLocation);
                                          isFavorite = true;
                                        });
                                  } else {
                                    dropError('CEP is alredy in favorites!');
                                  }
                                } else {
                                  final index = myLocations.indexOf(currentLocation);

                                  setState(() {
                                    myLocations.removeAt(index);
                                    isFavorite = false;
                                  });

                                }
                              },
                              icon: isFavorite ? Icon(Icons.star) : Icon(Icons.star_border)),
                          IconButton(
                              onPressed: () =>
                                  setState(() {
                                    currentLocation = null;
                                    isFavorite = false;
                                  }),
                              icon: Icon(Icons.highlight_remove_outlined))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            // My Locations
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: myLocations.length,
                    itemBuilder: (context, index) => Dismissible(
                      background: Container(
                        color: Colors.redAccent,
                      ),
                      key: Key(myLocations[index]['cep']),
                      onDismissed: (direction) {
                        if (currentLocation == myLocations[index]) {
                          isFavorite = false;
                        }
                        setState(() => myLocations.removeAt(index));
                      },
                      child: Card(
                        child: ListTile(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LocationPage(myLocations[index]))),
                          title: Text(myLocations[index]['cep']),
                          subtitle: Text('${myLocations[index]['localidade']} - ${myLocations[index]['uf']}'),
                          leading: Icon(Icons.location_on_outlined),
                        ),
                      )
                    )),
              )
            ),
          ],
        ),
      ),
    );
  }
}
