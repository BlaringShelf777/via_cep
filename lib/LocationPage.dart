
import 'package:flutter/material.dart';

class LocationPage extends StatelessWidget {
  final location;

  const LocationPage(this.location, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(location['cep']),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Wrap(
              runSpacing: 20,
              runAlignment: WrapAlignment.end,
              children: [
                Item(location['cep']),
                Item('${location['localidade']} - ${location['uf']}'),
                Item(location['logradouro']),
                Item(location['bairro']),
                Item('DDD: ${location['ddd']}'),
                Item('Ibge: ${location['ibge']}'),
                Item('Siafi: ${location['siafi']}')
              ],

        ),),);
  }
}

class Item extends StatelessWidget {
  final String text;

  const Item(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.all(Radius.circular(50))
        ),

        child: Text(text),
    );
  }
}

