import 'package:args/args.dart';
import 'package:clean_server/app.dart';

const String version = '0.0.1';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Show additional command output.',
    )
    ..addFlag('version', negatable: false, help: 'Print the tool version.')
    ..addOption(
      'port',
      abbr: 'p',
      defaultsTo: '8080',
      help: 'Port to listen on.',
    );
}

void printUsage(ArgParser argParser) {
  print('Usage: dart clean_server.dart <flags> [arguments]');
  print(argParser.usage);
}

void main(List<String> arguments) async {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);

    if (results.flag('help')) {
      printUsage(argParser);
      return;
    }
    if (results.flag('version')) {
      print('clean_server version: $version');
      return;
    }

    final int port = int.tryParse(results['port'] as String) ?? 8080;
    final bool verbose = results.flag('verbose');

    final app = App(port: port, verbose: verbose);
    await app.run();
  } on FormatException catch (e) {
    print(e.message);
    print('');
    printUsage(argParser);
  }
}
