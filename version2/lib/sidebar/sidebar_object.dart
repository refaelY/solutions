class SidebarObject {
  final String name;
  final Map<String, dynamic> structure;
  final Map<String, dynamic> behavior;
  final Map<String, dynamic> data;
  final Map<String, dynamic> presentation;

  const SidebarObject({
    required this.name,
    required this.structure,
    required this.behavior,
    required this.data,
    required this.presentation,
  });
}
