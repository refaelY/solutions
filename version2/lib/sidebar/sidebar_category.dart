import 'package:flutter/material.dart';

class SidebarCategory extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isSelected;
  const SidebarCategory({
    required this.icon,
    required this.label,
    this.onTap,
    this.isSelected = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected ? Colors.blue[100] : null,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            Text(label, style: TextStyle(fontSize: 16), textDirection: TextDirection.rtl),
            const SizedBox(width: 12),
            Icon(icon, color: Colors.blueGrey[700]),
          ],
        ),
      ),
    );
  }
}
