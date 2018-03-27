import 'dart:async';

import 'package:build_runner_benchmark/config.dart';
import 'package:build_runner_benchmark/src/structure_config.dart';
import 'package:logging/logging.dart';
import 'dart:io';
import 'package:path/path.dart';

class App{
  static final Logger _log = new Logger('App');
  final Config _config = new Config();
  String _templateContent;
  Directory _output;
  App(){
    _log.info("RUN");
    _output = new Directory(_config.outputFolder);
  }
  Future run([StructureConfig sc]) async{
    try {

      if (await _output.exists()) {
        //TODO: ENABLE!
//        output.delete(recursive: true);
      }

      await _populateTemplateContent();
      await _output.create(recursive: true);
      await _copyTemplateProject();
      await _createFakeStruct(sc);
    }catch(e, st){
      _log.severe("Error", e, st);
    }
  }

  Future _populateTemplateContent() async {
    File templateFile = new File(_config.template_file_path);
    if (templateFile.existsSync() == false){
      throw new Exception("Not found template file: '${_config.template_file_path}'");
    }
    _templateContent = await templateFile.readAsString();
  }

  Future _copyTemplateProject() async{
     var _templateProject = new Directory(_config.template_project_directory);
     if (! await _templateProject.exists()){
       throw new Exception("Not found template project: '${_config.template_project_directory}'");
     }
     _recursiveFolderCopySync(_templateProject.path, _output.path);
  }

  void _recursiveFolderCopySync(String path1, String path2) {
    Directory dir1 = new Directory(path1);
    if (!dir1.existsSync()) {
      throw new Exception(
          'Source directory "${dir1.path}" does not exist, nothing to copy'
      );
    }
    Directory dir2 = new Directory(path2);
    if (!dir2.existsSync()) {
      dir2.createSync(recursive: true);
    }

    dir1.listSync().forEach((element) {
      if (element
          .statSync()
          .type != FileSystemEntityType.LINK) {
        String newPath = join(dir2.path,basename(element.path));
        if (element is File) {
          File newFile = new File(newPath);
          newFile.writeAsBytesSync(element.readAsBytesSync());
        } else if (element is Directory) {
          _recursiveFolderCopySync(element.path, newPath);
        } else {
          throw new Exception('File is neither File nor Directory. HOW?!');
        }
      }
    });

  }

  static const String _libraryToken = '/*%LIBRARY%*/';
  static const String _importsToken = '/*%IMPORT%*/';
  static const String _uniqueToken = '/*%UNIQUE_ID%*/';
  static const String _lastCallToken = '/*%LAST_CALL%*/';
  static const String _callToken = '/*%CALL%*/';
  static const String _nameToken = '/*%NAME%*/';
  Future _createFakeStruct([StructureConfig sc]) async{
    if (sc == null){
      sc = new StructureConfig(new StructureNode()..populate(100, 100));
    }
    _createFakeFile(sc.root);
  }
  String _genFileName(int id)=>"part_${id}.dart";
  String _genImportNM(int id)=>"ID_${id}";
  Future _createFakeFile(StructureNode sn){
    StringBuffer importStr = new StringBuffer();
    var fList = <Future>[];
    sn.imports.forEach((subNode){
      fList.add(_createFakeFile(subNode));
      importStr.writeln("import 'package:build_runner_benchmark_test/${_genFileName(subNode.id)}' as ${_genImportNM(subNode.id)};");
    });
    StringBuffer callStr = new StringBuffer();
    sn.calls.forEach((subNode){
      callStr.writeln("${_genImportNM(subNode.id)}.main(),");
    });

    var newContent = _templateContent.replaceAll(_uniqueToken, sn.id.toString())
        .replaceAll (_importsToken, importStr.toString()).replaceAll(_callToken, callStr.toString());
    var outputFile = new File(join(_output.path,'lib','${_genFileName(sn.id)}'));
    fList.add(outputFile.writeAsString(newContent));
    return Future.wait<dynamic>(fList);
  }

}