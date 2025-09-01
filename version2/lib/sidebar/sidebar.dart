import 'package:flutter/material.dart';
import 'sidebar_category.dart';
import 'objects_data.dart';
import '../canvas/main_canvas_object.dart';
import 'sidebar_object.dart';

class Sidebar extends StatefulWidget {
		final void Function(MainCanvasObject)? onObjectSelected;
		const Sidebar({Key? key, this.onObjectSelected}) : super(key: key);

	@override
	State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
	String? selectedCategory;

		@override
		Widget build(BuildContext context) {
			final categories = [
				{'icon': Icons.code, 'label': 'תכנות'},
				{'icon': Icons.settings_input_component, 'label': 'חשמל/IoT'},
				{'icon': Icons.category, 'label': 'אובייקטים'},
				{'icon': Icons.image, 'label': 'מדיה'},
				{'icon': Icons.people, 'label': 'קהילה'},
			];
			final objectsMap = {
				'תכנות': programmingObjects,
				'חשמל/IoT': iotObjects,
						'אובייקטים': [
							SidebarObject(
								name: 'ריבוע',
								structure: {'type': 'ריבוע'},
								behavior: {},
								data: {},
								presentation: {'color': 0xFFB3E5FC},
							),
							SidebarObject(
								name: 'עיגול',
								structure: {'type': 'עיגול'},
								behavior: {},
								data: {},
								presentation: {'color': 0xFFFFF176},
							),
							SidebarObject(
								name: 'טקסט',
								structure: {'type': 'טקסט'},
								behavior: {},
								data: {},
								presentation: {'color': 0xFF81C784},
							),
							SidebarObject(
								name: 'כפתור',
								structure: {'type': 'כפתור'},
								behavior: {},
								data: {},
								presentation: {'color': 0xFF90CAF9},
							),
							SidebarObject(
								name: 'תמונה',
								structure: {'type': 'תמונה'},
								behavior: {},
								data: {},
								presentation: {'color': 0xFFD1C4E9},
							),
						],
				'מדיה': mediaObjects,
				'קהילה': communityObjects,
			};
				return Container(
					width: 230,
					color: Colors.blueGrey[50],
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.end,
						children: [
							const Padding(
								padding: EdgeInsets.all(16.0),
								child: Text('קטגוריות', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18) ,textDirection: TextDirection.rtl ),
							),
							...categories.map((cat) => SidebarCategory(
								icon: cat['icon'] as IconData,
								label: cat['label'] as String,
								onTap: () {
									setState(() {
										selectedCategory = cat['label'] as String;
									});
								},
								isSelected: selectedCategory == cat['label'],
							)),
							if (selectedCategory != null)
								Expanded(
									child: SingleChildScrollView(
										child: Column(
											children: [
                        ...objectsMap[selectedCategory]!.map((obj) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
                            child: Card(
                                elevation: 1,
                                child: GestureDetector(
                                  onDoubleTap: () {
                                    if (widget.onObjectSelected != null && obj is SidebarObject) {
                                      // יצירת MainCanvasObject מתוך SidebarObject
														final mainObj = MainCanvasObject(
															position: const Offset(600, 400),
															width: 260,
															height: 180,
															title: obj.name,
															settings: [obj.structure.toString()],
															legalSentences: [obj.behavior.toString()],
															managedObject: obj.data.toString(),
															fillColor: Color(obj.presentation['color'] ?? 0xFFB3E5FC),
															borderColor: const Color(0xFF0288D1),
															borderWidth: 4.0,
															blur: 8.0,
															id: obj.name,
															layers: const ['תצוגה' ,'כותרת', 'קישוריות', 'עיצוב'],
															structure: obj.structure,
														);
                                      widget.onObjectSelected!(mainObj);
                                    }
                                  },
                                  child: ListTile(
                                    title: Text(obj.name, textDirection: TextDirection.rtl),
                                    subtitle: Text('מבנה: ${obj.structure['type']}', textDirection: TextDirection.rtl, style: TextStyle(fontSize: 12)),
                                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                                  ),
                                ),
                            ),
                        )),
												const SizedBox(height: 16),
											],
										),
									),
								),
						],
					),
				);
	}
}
