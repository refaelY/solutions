import 'package:flutter/material.dart';
import 'sidebar/sidebar_category.dart';
import 'sidebar/sidebar.dart';
import 'components/edit_object_sidebar.dart';
import 'canvas/canvas3d.dart';
import 'canvas/main_canvas_object.dart';
import 'canvas/workspace_project.dart';
import 'components/top_menu_bar.dart';
import 'sidebar/objects_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  title: 'רפטק - פתרונות עבודה',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
  home: const MyHomePage(title: 'דף הבית'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _layerViewMode = 3; // 0: כותרת, 1: הגדרות, 2: משפטים, 3: עיצוב
  List<WorkspaceProject> _projects = [
    WorkspaceProject(id: 'default', name: 'פרויקט ראשי', objects: []),
  ];
  String? _selectedProjectId = 'default';

  WorkspaceProject get currentProject => _projects.firstWhere((p) => p.id == _selectedProjectId);

  MainCanvasObject? _editingObject;
  int _selectedLayerTab = 0;

  void _openEditSidebar(MainCanvasObject obj) {
    setState(() {
      _editingObject = obj;
      _selectedLayerTab = 0;
    });
  }

  void _closeEditSidebar() {
    setState(() {
      _editingObject = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Column(
          children: [
            // תפריט עליון
            TopMenuBar(
              projects: _projects.map((p) => p.name).toList(),
              selectedProject: currentProject.name,
              onSelectProject: (name) {
                setState(() {
                  final found = _projects.firstWhere((p) => p.name == name, orElse: () => _projects.first);
                  _selectedProjectId = found.id;
                });
              },
              onAddProject: () {
                setState(() {
                  final newId = 'project_${_projects.length + 1}';
                  _projects.add(WorkspaceProject(id: newId, name: 'פרויקט ${_projects.length + 1}', objects: []));
                  _selectedProjectId = newId;
                });
              },
            ),
            // כפתורי שכבות מעל הקנבס
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < 4; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(56, 32),
                          backgroundColor: i == _layerViewMode ? Colors.blue[700] : Colors.blue[400],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          setState(() => _layerViewMode = i);
                        },
                        child: Text(
                          [
                            'הרצה',
                            'כותרת',
                            'קישוריות',
                            'עיצוב',
                          ][i],
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  // Sidebar קטגוריות או עריכה
                  _editingObject == null
                    ? Sidebar(
                        onObjectSelected: (obj) {
                          setState(() {
                            currentProject.objects.add(obj);
                          });
                        },
                      )
                    : EditObjectSidebar(
                        object: _editingObject!,
                        selectedLayerIndex: _selectedLayerTab,
                        onTabChange: (i) => setState(() => _selectedLayerTab = i),
                        onParamChange: (key, value) {
                          setState(() {
                            switch (key) {
                              case 'title':
                                _editingObject!.title = value ?? '';
                                break;
                              case 'width':
                                if (value != null) _editingObject!.width = value;
                                break;
                              case 'height':
                                if (value != null) _editingObject!.height = value;
                                break;
                              case 'fillColor':
                                if (value != null) _editingObject!.fillColor = value;
                                break;
                              case 'borderColor':
                                if (value != null) _editingObject!.borderColor = value;
                                break;
                              case 'borderWidth':
                                if (value != null) _editingObject!.borderWidth = value;
                                break;
                              case 'blur':
                                if (value != null) _editingObject!.blur = value;
                                break;
                              case 'position.dx':
                                if (value != null) _editingObject!.position = Offset(value, _editingObject!.position.dy);
                                break;
                              case 'position.dy':
                                if (value != null) _editingObject!.position = Offset(_editingObject!.position.dx, value);
                                break;
                              case 'managedObject':
                                _editingObject!.managedObject = value ?? '';
                                break;
                              default:
                                if (key.startsWith('settings.')) {
                                  final idx = int.tryParse(key.split('.')[1] ?? '0');
                                  if (idx != null && idx < _editingObject!.settings.length) {
                                    _editingObject!.settings[idx] = value ?? '';
                                  }
                                } else if (key.startsWith('legalSentences.')) {
                                  final idx = int.tryParse(key.split('.')[1] ?? '0');
                                  if (idx != null && idx < _editingObject!.legalSentences.length) {
                                    _editingObject!.legalSentences[idx] = value ?? '';
                                  }
                                }
                            }
                          });
                        },
                      ),
                  // קנבס מרכזי
                  Expanded(
                    child: GestureDetector(
                      onTap: _closeEditSidebar,
                      child: Container(
                        color: Colors.blue[50],
                        child: Canvas3D(
                          objects: currentProject.objects,
                          onObjectDoubleTap: _openEditSidebar,
                          layerViewMode: _layerViewMode,
                          editingObject: _editingObject,
                          onCanvasTap: _closeEditSidebar,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
