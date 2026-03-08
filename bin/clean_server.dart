import 'dart:developer' as developer;
import 'package:args/args.dart';
import 'package:clean_server/app.dart';

const String version = '0.0.1';

/// Builds the argument parser for the CLI.
ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addOption(
      'port',
      abbr: 'p',
      help: 'Port to listen on.',
      defaultsTo: '8080',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Enable verbose logging.',
    )
    ..addFlag('version', negatable: false, help: 'Print the tool version.');
}

/// Prints the usage information.
void printUsage(ArgParser argParser) {
  developer.log('Usage: dart clean_server.dart [arguments]');
  developer.log(argParser.usage);
}

/// The main entry point for the CLI.
void main(List<String> arguments) async {
  final argParser = buildParser();
  try {
    final results = argParser.parse(arguments);

    // Process the parsed arguments.
    if (results.flag('help')) {
      printUsage(argParser);
      return;
    }
    if (results.flag('version')) {
      developer.log('clean_server version: $version');
      return;
    }

    final port = int.tryParse(results['port'] as String) ?? 8080;
    final verbose = results.flag('verbose');

    final app = App(port: port, verbose: verbose);
    await app.run();
  } on FormatException catch (e) {
    developer.log(e.message);
    developer.log('');
    printUsage(argParser);
  }
}
