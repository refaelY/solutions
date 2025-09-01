import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:vector_math/vector_math_64.dart' as vmath;
import 'main_canvas_object.dart';
import '../components/layer_panel.dart';
import 'package:flutter/gestures.dart';

class Canvas3D extends StatefulWidget {
  final List<MainCanvasObject> objects;
  final void Function(int oldIndex, int newIndex)? onReorderLayers;
  final void Function(MainCanvasObject)? onObjectDoubleTap;
  final VoidCallback? onCanvasTap;
  final int layerViewMode; // 0: כותרת, 1: הגדרות, 2: משפטים, 3: עיצוב
  final MainCanvasObject? editingObject;
  const Canvas3D({
    Key? key,
    required this.objects,
    this.onReorderLayers,
    this.onObjectDoubleTap,
    this.layerViewMode = 3,
    this.editingObject,
    this.onCanvasTap,
  }) : super(key: key);

	@override
	State<Canvas3D> createState() => _Canvas3DState();
}

class _Canvas3DState extends State<Canvas3D> {
  // מנהל את הזום והפאן של הקאנבס
  TransformationController _transformationController = TransformationController();
  // מפתח גלובלי לגישה ישירה ל-SizedBox של הקאנבס לצורך המרת קואורדינטות
  final GlobalKey _canvasKey = GlobalKey();
		void _showContextMenu(BuildContext context, Offset position) {
			showMenu(
				context: context,
				position: RelativeRect.fromLTRB(position.dx, position.dy, position.dx, position.dy),
				items: [
					PopupMenuItem(child: Text('הוסף אובייקט')), 
					PopupMenuItem(child: Text('שמור Snapshot')), 
					PopupMenuItem(child: Text('בטל פעולה')), 
					PopupMenuItem(child: Text('הגדרות קנבס')), 
				],
			);
		}

  @override
  void initState() {
    super.initState();
  // אין צורך ב-initState
  }

  void showObject(MainCanvasObject obj) {
  // פונקציה לא בשימוש
  }

  MainCanvasObject? _selectedObject;

  int? _draggingObjectIndex;
  Offset? _dragOffsetFromCenter;
  Offset? _lastTapPosition;
  int? _resizingHandleIndex;
  Offset? _initialResizePosition;
  double? _initialWidth;
  double? _initialHeight;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              Listener(
                onPointerDown: (event) {
                  if (event.kind == PointerDeviceKind.mouse && event.buttons == 2) {
                    _showContextMenu(context, event.position);
                  }
                },
                child: Center(
                  child: InteractiveViewer(
                    constrained: false,
                    boundaryMargin: EdgeInsets.zero,
                    minScale: 0.0001,
                    maxScale: 4.0,
                    transformationController: _transformationController,
                    panEnabled: true,
                    child: SizedBox(
                      key: _canvasKey, // חשוב! מאפשר גישה ישירה ל-SizedBox של הקאנבס
                      width: 5000,
                      height: 5000,
                      child: RawGestureDetector(
                        gestures: {
                          ScaleGestureRecognizer:
                              GestureRecognizerFactoryWithHandlers<ScaleGestureRecognizer>(
                            () => ScaleGestureRecognizer(),
                            (instance) {
                              instance
                                ..onStart = (details) {
                                  // התחלת גרירה/שינוי גודל/פאן
                                  _draggingObjectIndex = null;
                                  _dragOffsetFromCenter = null;
                                  _resizingHandleIndex = null;
                                  _initialResizePosition = null;
                                  _initialWidth = null;
                                  _initialHeight = null;
                                  // בדוק אם נלחצה ידית שינוי גודל
                                  for (int i = 0; i < widget.objects.length; i++) {
                                    final obj = widget.objects[i];
                                    final type = obj.structure['type'] ?? '';
                                    final rect = Rect.fromCenter(center: obj.position, width: obj.width + 40, height: obj.height + 40);
                                    if (_selectedObject == obj) {
                                      final handles = [
                                        rect.topLeft,
                                        rect.topRight,
                                        rect.bottomLeft,
                                        rect.bottomRight,
                                      ];
                                      for (int h = 0; h < handles.length; h++) {
                                        if ((details.localFocalPoint - handles[h]).distance < 16) {
                                          _resizingHandleIndex = h;
                                          _initialResizePosition = details.localFocalPoint;
                                          _initialWidth = obj.width;
                                          _initialHeight = obj.height;
                                          return;
                                        }
                                      }
                                    }
                                    // בדוק אם נלחץ אובייקט לגרירה
                                    if (rect.contains(details.localFocalPoint)) {
                                      _draggingObjectIndex = i;
                                      _dragOffsetFromCenter = details.localFocalPoint - obj.position;
                                      return;
                                    }
                                  }
                                }
                                ..onUpdate = (details) {
                                  // שינוי גודל
                                  if (_selectedObject != null && _resizingHandleIndex != null && _initialResizePosition != null) {
                                    final dx = details.localFocalPoint.dx - _initialResizePosition!.dx;
                                    final dy = details.localFocalPoint.dy - _initialResizePosition!.dy;
                                    setState(() {
                                      switch (_resizingHandleIndex) {
                                        case 0: // topLeft
                                          _selectedObject!.width = max(40, (_initialWidth! - dx));
                                          _selectedObject!.height = max(40, (_initialHeight! - dy));
                                          break;
                                        case 1: // topRight
                                          _selectedObject!.width = max(40, (_initialWidth! + dx));
                                          _selectedObject!.height = max(40, (_initialHeight! - dy));
                                          break;
                                        case 2: // bottomLeft
                                          _selectedObject!.width = max(40, (_initialWidth! - dx));
                                          _selectedObject!.height = max(40, (_initialHeight! + dy));
                                          break;
                                        case 3: // bottomRight
                                          _selectedObject!.width = max(40, (_initialWidth! + dx));
                                          _selectedObject!.height = max(40, (_initialHeight! + dy));
                                          break;
                                      }
                                    });
                                  }
                                  // גרירת אובייקט
                                  else if (_draggingObjectIndex != null && details.scale == 1.0) {
                                    setState(() {
                                      final obj = widget.objects[_draggingObjectIndex!];
                                      obj.position = details.localFocalPoint - (_dragOffsetFromCenter ?? Offset.zero);
                                    });
                                  }
                                  // פאן של הקאנבס
                                  else if (_draggingObjectIndex == null && _resizingHandleIndex == null && details.scale == 1.0) {
                                    _transformationController.value = _transformationController.value.clone()
                                      ..translate(details.focalPointDelta.dx, details.focalPointDelta.dy);
                                  }
                                }
                                ..onEnd = (_) {
                                  _draggingObjectIndex = null;
                                  _dragOffsetFromCenter = null;
                                  _resizingHandleIndex = null;
                                  _initialResizePosition = null;
                                  _initialWidth = null;
                                  _initialHeight = null;
                                };
                            },
                          ),
                        },
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTapDown: (details) {
                            _lastTapPosition = details.localPosition;
                            // בחירת אובייקט
                            for (int i = 0; i < widget.objects.length; i++) {
                              final obj = widget.objects[i];
                              final type = obj.structure['type'] ?? '';
                              final rect = Rect.fromCenter(center: obj.position, width: obj.width + 40, height: obj.height + 40);
                              if (rect.contains(details.localPosition) && (type == 'ריבוע' || type == 'טקסט' || type == 'עיגול')) {
                                setState(() {
                                  _selectedObject = obj;
                                });
                                break;
                              }
                            }
                            if (widget.onCanvasTap != null) {
                              widget.onCanvasTap!();
                            }
                          },
                          onDoubleTap: () {
                            if (_lastTapPosition == null) return;
                            final local = _lastTapPosition!;
                            for (int i = 0; i < widget.objects.length; i++) {
                              final obj = widget.objects[i];
                              final rect = Rect.fromCenter(center: obj.position, width: obj.width + 40, height: obj.height + 40);
                              if (rect.contains(local)) {
                                setState(() {
                                  _selectedObject = obj;
                                });
                                widget.onObjectDoubleTap?.call(obj);
                                return;
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        LayerPanel(
          objects: widget.objects,
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final obj = widget.objects.removeAt(oldIndex);
              widget.objects.insert(newIndex, obj);
            });
            if (widget.onReorderLayers != null) {
              widget.onReorderLayers!(oldIndex, newIndex);
            }
          },
        ),
      ],
    );

	}
      bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
    }
  
  // Add the missing _Canvas3DPainter class
  class _Canvas3DPainter extends CustomPainter {
    final List<MainCanvasObject> canvasObjects;
    final int layerViewMode;
    final MainCanvasObject? editingObject;
    final MainCanvasObject? selectedObject;

    _Canvas3DPainter({
      required this.canvasObjects,
      required this.layerViewMode,
      required this.editingObject,
      required this.selectedObject,
    });

    void _drawResizeHandles(Canvas canvas, Rect rect) {
      final handleSize = 16.0;
      final paint = Paint()
        ..color = Colors.blueAccent
        ..style = PaintingStyle.fill;
      // פינות: שמאל-עליון, ימין-עליון, שמאל-תחתון, ימין-תחתון
      final handles = [
        rect.topLeft,
        rect.topRight,
        rect.bottomLeft,
        rect.bottomRight,
      ];
      for (final pos in handles) {
        canvas.drawRect(
          Rect.fromCenter(center: pos, width: handleSize, height: handleSize),
          paint,
        );
      }
    }

    @override
    void paint(Canvas canvas, Size size) {
      for (final obj in canvasObjects) {
        final type = obj.structure['type'] ?? 'ריבוע';
        final rect = Rect.fromCenter(center: obj.position, width: obj.width, height: obj.height);
        final fillPaint = Paint()
          ..color = obj.fillColor
          ..style = PaintingStyle.fill;
        final borderPaint = Paint()
          ..color = obj.borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = obj.borderWidth;

        bool isSelected = selectedObject == obj;

        if (type == 'ריבוע') {
          canvas.drawRect(rect, fillPaint);
          canvas.drawRect(rect, borderPaint);
          if (isSelected) _drawResizeHandles(canvas, rect);
        } else if (type == 'עיגול') {
          final radius = (obj.width + obj.height) / 4;
          canvas.drawCircle(obj.position, radius, fillPaint);
          canvas.drawCircle(obj.position, radius, borderPaint);
          if (isSelected) {
            final handleSize = 16.0;
            final paint = Paint()
              ..color = Colors.blueAccent
              ..style = PaintingStyle.fill;
            final angles = [0.0, 90.0, 180.0, 270.0];
            for (final angle in angles) {
              final rad = vmath.radians(angle);
              final pos = Offset(
                obj.position.dx + radius * cos(rad),
                obj.position.dy + radius * sin(rad),
              );
              canvas.drawRect(
                Rect.fromCenter(center: pos, width: handleSize, height: handleSize),
                paint,
              );
            }
          }
        } else if (type == 'טקסט') {
          // ציור טקסט בלבד, ללא רקע וללא גבול
          final displayText = (obj.text.isEmpty) ? 'התחל להקליד' : obj.text;
          final textSpan = TextSpan(text: displayText, style: const TextStyle(fontSize: 22, color: Colors.black));
          final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.rtl, textAlign: TextAlign.center);
          textPainter.layout(maxWidth: rect.width - 16);
          final offset = Offset(obj.position.dx - textPainter.width / 2, obj.position.dy - textPainter.height / 2);
          textPainter.paint(canvas, offset);
          if (isSelected) _drawResizeHandles(canvas, rect);
        } else if (type == 'כפתור') {
          // ציור כפתור כמלבן עם טקסט
          canvas.drawRect(rect, fillPaint);
          canvas.drawRect(rect, borderPaint);
          final textSpan = TextSpan(text: obj.title.isNotEmpty ? obj.title : 'כפתור', style: const TextStyle(fontSize: 18, color: Colors.white));
          final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.rtl, textAlign: TextAlign.center);
          textPainter.layout(maxWidth: rect.width - 16);
          final offset = Offset(obj.position.dx - textPainter.width / 2, obj.position.dy - textPainter.height / 2);
          textPainter.paint(canvas, offset);
        } else if (type == 'תמונה') {
          // ציור רקע לתמונה (אפשר להוסיף תמיכה ב-Image בעתיד)
          canvas.drawRect(rect, fillPaint);
          canvas.drawRect(rect, borderPaint);
          final textSpan = TextSpan(text: 'תמונה', style: const TextStyle(fontSize: 18, color: Colors.black54));
          final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.rtl, textAlign: TextAlign.center);
          textPainter.layout(maxWidth: rect.width - 16);
          final offset = Offset(obj.position.dx - textPainter.width / 2, obj.position.dy - textPainter.height / 2);
          textPainter.paint(canvas, offset);
        } else {
          // ברירת מחדל: ריבוע
          canvas.drawRect(rect, fillPaint);
          canvas.drawRect(rect, borderPaint);
        }

        // ציור טקסטים נוספים לפי מצב שכבה
        final padding = 16.0;
        final left = rect.left + padding;
        double top = rect.top + padding;

        if (layerViewMode == 1) {
          // Title mode: only the name above the object
          final titleSpan = TextSpan(text: obj.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black));
          final titlePainter = TextPainter(text: titleSpan, textDirection: TextDirection.rtl);
          titlePainter.layout(maxWidth: rect.width - 2 * padding);
          titlePainter.paint(canvas, Offset(left, rect.top - titlePainter.height - 8));
        } else if (layerViewMode == 2) {
          // Settings mode: show only settings
          double settingsTop = top;
          for (final setting in obj.settings) {
            final settingSpan = TextSpan(text: setting, style: const TextStyle(fontSize: 15, color: Colors.black87));
            final settingPainter = TextPainter(text: settingSpan, textDirection: TextDirection.rtl);
            settingPainter.layout(maxWidth: rect.width - 2 * padding);
            settingPainter.paint(canvas, Offset(left, settingsTop));
            settingsTop += settingPainter.height + 6;
          }
        }
      }
    }
  
    @override
    bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
  }

