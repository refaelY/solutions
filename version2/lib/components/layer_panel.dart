import 'package:flutter/material.dart';
import '../canvas/main_canvas_object.dart';

class LayerPanel extends StatelessWidget {
  final List<MainCanvasObject> objects;
  final void Function(int oldIndex, int newIndex)? onReorder;

  const LayerPanel({Key? key, required this.objects, this.onReorder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: Colors.blueGrey[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text('שכבות ואובייקטים', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ),
          Expanded(
            child: ReorderableListView(
              buildDefaultDragHandles: true,
              onReorder: onReorder ?? (oldIndex, newIndex) {},
              children: [
                for (int i = 0; i < objects.length; i++)
                  ListTile(
                    key: ValueKey(objects[i].id),
                    title: Text(objects[i].title, textDirection: TextDirection.rtl),
                    subtitle: Text('מיקום: ${objects[i].position.dx.toInt()},${objects[i].position.dy.toInt()} | גודל: ${objects[i].width.toInt()}x${objects[i].height.toInt()}', style: TextStyle(fontSize: 12)),
                    leading: const Icon(Icons.drag_handle),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
