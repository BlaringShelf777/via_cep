import 'package:flutter/material.dart';
import 'package:via_cep/getCep.dart';

void main() => runApp(MaterialApp(
      title: 'GetCep',
      theme: ThemeData(primaryColor: Colors.green),
      home: GetCep(),
      debugShowCheckedModeBanner: false,
    ));
