import 'package:flutter/material.dart';
import 'main_canvas_object.dart';

class WorkspaceProject {
  final String id;
  String name;
  List<MainCanvasObject> objects;
  Map<String, dynamic> designSettings;
  Map<String, dynamic> metaSettings;
  // קשרים בין אובייקטים (בהמשך)
  // Map<String, List<String>> relations;

  WorkspaceProject({
    required this.id,
    required this.name,
    this.objects = const [],
    this.designSettings = const {},
    this.metaSettings = const {},
    // this.relations = const {},
  });

  WorkspaceProject copyWith({
    String? id,
    String? name,
    List<MainCanvasObject>? objects,
    Map<String, dynamic>? designSettings,
    Map<String, dynamic>? metaSettings,
    // Map<String, List<String>>? relations,
  }) {
    return WorkspaceProject(
      id: id ?? this.id,
      name: name ?? this.name,
      objects: objects ?? this.objects,
      designSettings: designSettings ?? this.designSettings,
      metaSettings: metaSettings ?? this.metaSettings,
      // relations: relations ?? this.relations,
    );
  }
}
