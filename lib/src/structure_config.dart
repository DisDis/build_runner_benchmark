class StructureConfig{
  final StructureNode root;

  StructureConfig(this.root);
}

class StructureNode{
  final int id;
  final List<StructureNode> imports = <StructureNode>[];
  final List<StructureNode> calls = <StructureNode>[];

  StructureNode([int id]): this.id = id??_idCount++;

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