import 'dart:convert';
import 'dart:io';
import 'package:build/build.dart';
import 'package:build_runner/src/asset_graph/graph.dart';
import 'package:build_runner/src/asset_graph/node.dart';
import 'package:logging/logging.dart';

class StructureConfig{
  static final Logger _log = new Logger('StructureConfig');
  final StructureNode root;

  StructureConfig(this.root);
}

class StructureNode{
  final int id;
  final String name;
  final List<StructureNode> imports = <StructureNode>[];
  final List<StructureNode> calls = <StructureNode>[];

  StructureNode({int id, this.name}): this.id = id??_idCount++;

  static int _idCount = 0;
  void populate(int countImport, int countCall){
    if (countCall> countImport){
      countCall = countImport;
    }
    imports.clear();
    calls.clear();
    for(var i = 0; i < countImport ; i++){
      imports.add(new StructureNode());
    }
    for(var i = 0; i < countCall ; i++){
      calls.add(imports[i]);
    }
  }
}