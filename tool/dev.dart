library tool.dev;

import 'package:dart_dev/dart_dev.dart' show dev, config;

main(List<String> args) async {

  config.coverage.reportOn = ['web/'];
  config.test
    ..platforms = ['vm', 'firefox'];

  await dev(args);
}
