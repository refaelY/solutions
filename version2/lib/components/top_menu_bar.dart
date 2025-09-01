import 'package:flutter/material.dart';

class TopMenuBar extends StatelessWidget {
  final List<String> projects;
  final String? selectedProject;
  final ValueChanged<String?>? onSelectProject;
  final VoidCallback? onAddProject;

  const TopMenuBar({
    Key? key,
    required this.projects,
    this.selectedProject,
    this.onSelectProject,
    this.onAddProject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: Colors.blueGrey[100],
      child: Row(
        children: [
          const SizedBox(width: 16),
          Text('מרחבי עבודה:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(width: 16),
          DropdownButton<String>(
            value: selectedProject,
            hint: const Text('בחר פרויקט'),
            items: projects.map((p) => DropdownMenuItem(
              value: p,
              child: Text(p, style: const TextStyle(fontSize: 16)),
            )).toList(),
            onChanged: onSelectProject,
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: onAddProject,
            icon: const Icon(Icons.add),
            label: const Text('הוסף פרויקט'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[300],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}
