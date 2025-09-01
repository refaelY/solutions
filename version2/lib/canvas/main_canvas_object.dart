import 'package:flutter/material.dart';

class MainCanvasObject {
  MainCanvasObject copyWith({
    Offset? position,
    double? width,
    double? height,
    String? title,
    List<String>? settings,
    List<String>? legalSentences,
    String? managedObject,
    Color? fillColor,
    Color? borderColor,
    double? borderWidth,
    double? blur,
    String? id,
    List<String>? layers,
    Map<String, dynamic>? structure,
  }) {
    return MainCanvasObject(
      position: position ?? this.position,
      width: width ?? this.width,
      height: height ?? this.height,
      title: title ?? this.title,
      settings: settings ?? this.settings,
      legalSentences: legalSentences ?? this.legalSentences,
      managedObject: managedObject ?? this.managedObject,
      fillColor: fillColor ?? this.fillColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      blur: blur ?? this.blur,
      id: id ?? this.id,
      layers: layers ?? this.layers,
      structure: structure ?? this.structure,
    );
  }
  Offset position;
  double width;
  double height;
  String title;
  String text;
  List<String> settings;
  List<String> legalSentences;
  String managedObject;
  Color fillColor;
  Color borderColor;
  double borderWidth;
  double blur;
  String id;
  List<String> layers;
  // ...existing code...
  Map<String, dynamic> structure;

  MainCanvasObject({
    required this.position,
    required this.width,
    required this.height,
    this.title = 'כותרת ראשית',
    this.text = '',
    this.settings = const ['הגדרה 1', 'הגדרה 2'],
    this.legalSentences = const ['משפט ניהול 1', 'משפט ניהול 2'],
    this.managedObject = 'אובייקט מנוהל',
    this.fillColor = const Color(0xFFB3E5FC),
    this.borderColor = const Color(0xFF0288D1),
    this.borderWidth = 4.0,
    this.blur = 8.0,
    this.id = '',
    this.layers = const ['תצוגה' ,'כותרת', 'קישוריות', 'עיצוב'],
    Map<String, dynamic>? structure,
  }) : structure = structure ?? const {'type': 'ריבוע'};

  // אפשר להוסיף כאן תכונות נוספות בעתיד (צבע, מזהה, שכבות וכו')
}
