class Config{
  final String template_project_directory = "template_project";

  final String outputFolder = "output";
  Config._();
  static final _instance = new Config._();
  factory Config(){
    return _instance;
  }

  final String template_file_path  = 'lib/src/dart_file_template.dart';
}