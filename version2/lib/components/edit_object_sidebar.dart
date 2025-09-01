
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../canvas/main_canvas_object.dart';

class EditObjectSidebar extends StatefulWidget {
  final MainCanvasObject object;
  final int selectedLayerIndex;
  final void Function(int layerIndex)? onTabChange;
  final void Function(String key, dynamic value)? onParamChange;

  const EditObjectSidebar({
    Key? key,
    required this.object,
    required this.selectedLayerIndex,
    this.onTabChange,
    this.onParamChange,
  }) : super(key: key);

  @override
  State<EditObjectSidebar> createState() => _EditObjectSidebarState();
}

class _EditObjectSidebarState extends State<EditObjectSidebar> {
  late MainCanvasObject object;
  late int selectedLayerIndex;

  @override
  void initState() {
    super.initState();
    object = widget.object;
    selectedLayerIndex = widget.selectedLayerIndex;
  }

  void _updateParam(String key, dynamic value) {
    setState(() {
      switch (key) {
        case 'title':
          object.title = value ?? '';
          break;
        case 'width':
          if (value != null) object.width = value;
          break;
        case 'height':
          if (value != null) object.height = value;
          break;
        case 'fillColor':
          if (value != null) object.fillColor = value;
          break;
        case 'borderColor':
          if (value != null) object.borderColor = value;
          break;
        case 'borderWidth':
          if (value != null) object.borderWidth = value;
          break;
        case 'blur':
          if (value != null) object.blur = value;
          break;
        case 'position.dx':
          if (value != null) object.position = Offset(value, object.position.dy);
          break;
        case 'position.dy':
          if (value != null) object.position = Offset(object.position.dx, value);
          break;
        case 'managedObject':
          object.managedObject = value ?? '';
          break;
        default:
          if (key.startsWith('settings.')) {
            final idx = int.tryParse(key.split('.')[1]);
            if (idx != null && idx < object.settings.length) {
              object.settings[idx] = value ?? '';
            }
          } else if (key.startsWith('legalSentences.')) {
            final idx = int.tryParse(key.split('.')[1]);
            if (idx != null && idx < object.legalSentences.length) {
              object.legalSentences[idx] = value ?? '';
            }
          }
      }
    });
    widget.onParamChange?.call(key, value);
  }

  @override
  Widget build(BuildContext context) {
  // int tabIndex = selectedLayerIndex; // unused
    return Container(
      width: 320,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // טאבים: טקסט | אובייקט
          Container(
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 2; i++)
                  GestureDetector(
                    onTap: () => setState(() => selectedLayerIndex = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: selectedLayerIndex == i ? Colors.blue[100] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(i == 0 ? 'טקסט' : 'אובייקט', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: selectedLayerIndex == 0
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ListTile(
                          title: const Text('שם האובייקט'),
                          trailing: SizedBox(
                            width: 120,
                            child: TextFormField(
                              initialValue: object.title,
                              onChanged: (v) => _updateParam('title', v),
                            ),
                          ),
                        ),
                        if (object.structure['type'] == 'טקסט')
                          ListTile(
                            title: const Text('טקסט מוצג'),
                            trailing: SizedBox(
                              width: 120,
                              child: TextFormField(
                                initialValue: object.text,
                                onChanged: (v) => _updateParam('text', v),
                              ),
                            ),
                          ),
                        ListTile(
                          title: const Text('גודל טקסט'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Slider(
                                value: 18,
                                min: 8,
                                max: 72,
                                divisions: 64,
                                label: '18',
                                onChanged: (v) {}, // אפשרות להוסיף שדה גודל טקסט
                              ),
                              SizedBox(width: 8),
                              Text('18', style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        ListTile(
                          title: const Text('צבע טקסט'),
                          trailing: GestureDetector(
                            onTap: () async {
                              await showDialog<Color>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('בחר צבע טקסט'),
                                  content: SingleChildScrollView(
                                    child: BlockPicker(
                                      pickerColor: Colors.black,
                                      onColorChanged: (c) => Navigator.of(ctx).pop(c),
                                    ),
                                  ),
                                ),
                              );
                              // אפשרות להוסיף שדה צבע טקסט
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black12),
                              ),
                            ),
                          ),
                        ),
                        // אפשר להוסיף עוד שדות טקסט: יישור, הדגשה, נטוי וכו'
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ListTile(
                          title: const Text('צבע רקע'),
                          trailing: GestureDetector(
                            onTap: () async {
                              final color = await showDialog<Color>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('בחר צבע רקע'),
                                  content: SingleChildScrollView(
                                    child: BlockPicker(
                                      pickerColor: object.fillColor,
                                      onColorChanged: (c) => Navigator.of(ctx).pop(c),
                                    ),
                                  ),
                                ),
                              );
                              if (color != null) _updateParam('fillColor', color);
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: object.fillColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black12),
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          title: const Text('צבע גבול'),
                          trailing: GestureDetector(
                            onTap: () async {
                              final color = await showDialog<Color>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('בחר צבע גבול'),
                                  content: SingleChildScrollView(
                                    child: BlockPicker(
                                      pickerColor: object.borderColor,
                                      onColorChanged: (c) => Navigator.of(ctx).pop(c),
                                    ),
                                  ),
                                ),
                              );
                              if (color != null) _updateParam('borderColor', color);
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: object.borderColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black12),
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          title: const Text('רוחב גבול'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Slider(
                                value: object.borderWidth,
                                min: 0,
                                max: 20,
                                divisions: 20,
                                label: object.borderWidth.toStringAsFixed(1),
                                onChanged: (v) => setState(() => _updateParam('borderWidth', v)),
                              ),
                              SizedBox(width: 8),
                              Text(object.borderWidth.toStringAsFixed(1), style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        ListTile(
                          title: const Text('טשטוש'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Slider(
                                value: object.blur,
                                min: 0,
                                max: 30,
                                divisions: 30,
                                label: object.blur.toStringAsFixed(1),
                                onChanged: (v) => setState(() => _updateParam('blur', v)),
                              ),
                              SizedBox(width: 8),
                              Text(object.blur.toStringAsFixed(1), style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        ListTile(
                          title: const Text('רוחב'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Slider(
                                value: object.width,
                                min: 10,
                                max: 1000,
                                divisions: 99,
                                label: object.width.toStringAsFixed(1),
                                onChanged: (v) => setState(() => _updateParam('width', v)),
                              ),
                              SizedBox(width: 8),
                              Text(object.width.toStringAsFixed(1), style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        ListTile(
                          title: const Text('גובה'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Slider(
                                value: object.height,
                                min: 10,
                                max: 1000,
                                divisions: 99,
                                label: object.height.toStringAsFixed(1),
                                onChanged: (v) => setState(() => _updateParam('height', v)),
                              ),
                              SizedBox(width: 8),
                              Text(object.height.toStringAsFixed(1), style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        ListTile(
                          title: const Text('מיקום אופקי'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Slider(
                                value: object.position.dx,
                                min: 0,
                                max: 1000,
                                divisions: 100,
                                label: object.position.dx.toStringAsFixed(1),
                                onChanged: (v) => setState(() => _updateParam('position.dx', v)),
                              ),
                              SizedBox(width: 8),
                              Text(object.position.dx.toStringAsFixed(1), style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        ListTile(
                          title: const Text('מיקום אנכי'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Slider(
                                value: object.position.dy,
                                min: 0,
                                max: 1000,
                                divisions: 100,
                                label: object.position.dy.toStringAsFixed(1),
                                onChanged: (v) => setState(() => _updateParam('position.dy', v)),
                              ),
                              SizedBox(width: 8),
                              Text(object.position.dy.toStringAsFixed(1), style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        // אפשר להוסיף עוד שדות עיצוב ואפקטים
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
