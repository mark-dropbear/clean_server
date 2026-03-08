import 'package:args/args.dart';
import 'package:clean_server/app.dart';
import 'package:clean_server/core/logging.dart';
import 'package:logging/logging.dart';

const String version = '0.0.1';

final _logger = Logger('CLI');

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
  _logger.info('Usage: dart clean_server.dart [arguments]');
  _logger.info(argParser.usage);
}

/// The main entry point for the CLI.
void main(List<String> arguments) async {
  final argParser = buildParser();
  try {
    final results = argParser.parse(arguments);

    final verbose = results.flag('verbose');
    initLogging(verbose: verbose);

    // Process the parsed arguments.
    if (results.flag('help')) {
      printUsage(argParser);
      return;
    }
    if (results.flag('version')) {
      _logger.info('clean_server version: $version');
      return;
    }

    final port = int.tryParse(results['port'] as String) ?? 8080;

    final app = App(port: port, verbose: verbose);
    await app.run();
  } on FormatException catch (e) {
    _logger.severe(e.message);
    printUsage(argParser);
  }
}
