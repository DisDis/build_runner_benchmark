import 'dart:async';

import 'package:build_runner_benchmark/app.dart';
import 'package:build_runner_benchmark/src/project_cloner.dart';
import 'package:build_runner_benchmark/src/structure_config.dart';
import 'package:logging/logging.dart';
import 'package:logging/logging.dart' show Logger, Level, LogRecord;
import 'dart:isolate';
import 'package:args/args.dart';

void initLog([String isolateMarker]) {
  if (isolateMarker == null){
    isolateMarker = "I${Isolate.current.hashCode}";
  }
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    StringBuffer message = new StringBuffer();
    message.write('[$isolateMarker] ${rec.level.name}:${rec.loggerName} ${rec.time}: ${rec.message}');
    if (rec.error != null) {
      message.write(' ${rec.error}');
    }
    print(message);
  });
}


Future main(List<String> params) async {
  initLog();
  var parser = new ArgParser();
  parser.addOption('project', abbr:'p', help:'Project root', valueHelp: 'path');
  print("Options");
  print(parser.usage);
  var args = parser.parse(params);
//  var graph = args['graph'];
  StructureConfig sc = null;
  if (args.wasParsed('project')){
    sc = new ProjectCloner(args['project'] as String).execute();
  }
  await new App().run(sc);
}

