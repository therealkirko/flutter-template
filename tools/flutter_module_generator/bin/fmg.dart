#!/usr/bin/env dart

import 'dart:io';
import 'package:args/args.dart';
import 'package:flutter_module_generator/commands/create_command.dart';
import 'package:flutter_module_generator/commands/help_command.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addCommand('create')
    ..addCommand('help')
    ..addFlag('version', abbr: 'v', help: 'Print version', negatable: false)
    ..addFlag('help', abbr: 'h', help: 'Print usage', negatable: false);

  try {
    final results = parser.parse(arguments);

    if (results['version']) {
      print('Flutter Module Generator v1.0.0');
      exit(0);
    }

    if (results['help'] || results.command == null) {
      HelpCommand.show();
      exit(0);
    }

    switch (results.command?.name) {
      case 'create':
        await CreateCommand.execute(results.command!);
        break;
      case 'help':
        HelpCommand.show();
        break;
      default:
        print('Unknown command: ${results.command?.name}');
        HelpCommand.show();
        exit(1);
    }
  } catch (e) {
    print('Error: $e');
    HelpCommand.show();
    exit(1);
  }
}
