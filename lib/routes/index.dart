import 'package:flutter/material.dart';
import 'package:template/src/screens/index.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch(settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => MainPage());
      default: 
        return MaterialPageRoute(builder: (context) => Container(
          child: const Center(
            child: Text(
              'Default Page'
            )
          )
        ));
    };
  } 
}