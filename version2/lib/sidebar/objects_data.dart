import 'sidebar_object.dart';

const programmingObjects = [
  SidebarObject(
    name: 'פונקציה',
    structure: {'type': 'function', 'params': []},
    behavior: {'onCall': 'מבצע פעולה'},
    data: {'returnType': 'void'},
    presentation: {'icon': 'code', 'color': 0xFF1976D2},
  ),
  SidebarObject(
    name: 'משתנה',
    structure: {'type': 'variable'},
    behavior: {'onChange': 'עדכון ערך'},
    data: {'value': null},
    presentation: {'icon': 'tune', 'color': 0xFF388E3C},
  ),
  SidebarObject(
    name: 'תנאי (if)',
    structure: {'type': 'condition'},
    behavior: {'onTrue': 'מבצע פעולה'},
    data: {'condition': true},
    presentation: {'icon': 'help', 'color': 0xFFFBC02D},
  ),
  SidebarObject(
    name: 'לולאה (for)',
    structure: {'type': 'loop'},
    behavior: {'onIterate': 'מבצע פעולה'},
    data: {'count': 0},
    presentation: {'icon': 'repeat', 'color': 0xFF7B1FA2},
  ),
  SidebarObject(
    name: 'שירות API',
    structure: {'type': 'service'},
    behavior: {'onRequest': 'שליחת בקשה'},
    data: {'endpoint': ''},
    presentation: {'icon': 'cloud', 'color': 0xFF0288D1},
  ),
];

const iotObjects = [
  SidebarObject(
    name: 'נגד',
    structure: {'type': 'resistor'},
    behavior: {'onConnect': 'מעביר זרם'},
    data: {'ohm': 220},
    presentation: {'icon': 'settings_input_component', 'color': 0xFF795548},
  ),
  SidebarObject(
    name: 'קבל',
    structure: {'type': 'capacitor'},
    behavior: {'onCharge': 'אוגר מטען'},
    data: {'farad': 100},
    presentation: {'icon': 'battery_charging_full', 'color': 0xFF009688},
  ),
  SidebarObject(
    name: 'חיישן טמפרטורה',
    structure: {'type': 'sensor'},
    behavior: {'onDetect': 'מדווח ערך'},
    data: {'temp': 0},
    presentation: {'icon': 'device_thermostat', 'color': 0xFFD84315},
  ),
  SidebarObject(
    name: 'מפסק',
    structure: {'type': 'switch'},
    behavior: {'onToggle': 'שינוי מצב'},
    data: {'state': false},
    presentation: {'icon': 'toggle_on', 'color': 0xFF607D8B},
  ),
  SidebarObject(
    name: 'LED',
    structure: {'type': 'led'},
    behavior: {'onLight': 'הדלקה'},
    data: {'color': 'אדום'},
    presentation: {'icon': 'lightbulb', 'color': 0xFFFFEB3B},
  ),
];

const variableObjects = [
  SidebarObject(
    name: 'משתנה גלובלי',
    structure: {'type': 'global'},
    behavior: {'onChange': 'עדכון ערך'},
    data: {'value': null},
    presentation: {'icon': 'public', 'color': 0xFF1976D2},
  ),
  SidebarObject(
    name: 'משתנה מקומי',
    structure: {'type': 'local'},
    behavior: {'onChange': 'עדכון ערך'},
    data: {'value': null},
    presentation: {'icon': 'location_on', 'color': 0xFF388E3C},
  ),
  SidebarObject(
    name: 'קונפיגורציה',
    structure: {'type': 'config'},
    behavior: {'onUpdate': 'עדכון הגדרות'},
    data: {'settings': {}},
    presentation: {'icon': 'settings', 'color': 0xFF7B1FA2},
  ),
  SidebarObject(
    name: 'מצב (State)',
    structure: {'type': 'state'},
    behavior: {'onChange': 'עדכון מצב'},
    data: {'state': null},
    presentation: {'icon': 'sync', 'color': 0xFFFBC02D},
  ),
  SidebarObject(
    name: 'מזהה (ID)',
    structure: {'type': 'id'},
    behavior: {'onAssign': 'קביעת מזהה'},
    data: {'id': ''},
    presentation: {'icon': 'fingerprint', 'color': 0xFF0288D1},
  ),
];

const mediaObjects = [
  SidebarObject(
    name: 'תמונה',
    structure: {'type': 'image'},
    behavior: {'onLoad': 'טעינת תמונה'},
    data: {'src': ''},
    presentation: {'icon': 'image', 'color': 0xFF1976D2},
  ),
  SidebarObject(
    name: 'וידאו',
    structure: {'type': 'video'},
    behavior: {'onPlay': 'ניגון וידאו'},
    data: {'src': ''},
    presentation: {'icon': 'videocam', 'color': 0xFFD84315},
  ),
  SidebarObject(
    name: 'אודיו',
    structure: {'type': 'audio'},
    behavior: {'onPlay': 'ניגון אודיו'},
    data: {'src': ''},
    presentation: {'icon': 'audiotrack', 'color': 0xFF388E3C},
  ),
  SidebarObject(
    name: 'מסנן (Filter)',
    structure: {'type': 'filter'},
    behavior: {'onApply': 'הפעלת מסנן'},
    data: {'type': ''},
    presentation: {'icon': 'filter_alt', 'color': 0xFF7B1FA2},
  ),
  SidebarObject(
    name: 'אנימציה',
    structure: {'type': 'animation'},
    behavior: {'onStart': 'הפעלת אנימציה'},
    data: {'duration': 0},
    presentation: {'icon': 'animation', 'color': 0xFFFBC02D},
  ),
];

const communityObjects = [
  SidebarObject(
    name: 'אובייקט שפורסם',
    structure: {'type': 'published'},
    behavior: {'onShare': 'שיתוף'},
    data: {'owner': ''},
    presentation: {'icon': 'share', 'color': 0xFF0288D1},
  ),
  SidebarObject(
    name: 'תגית',
    structure: {'type': 'tag'},
    behavior: {'onAssign': 'שיוך תגית'},
    data: {'tag': ''},
    presentation: {'icon': 'label', 'color': 0xFF388E3C},
  ),
  SidebarObject(
    name: 'דירוג',
    structure: {'type': 'rating'},
    behavior: {'onRate': 'מתן דירוג'},
    data: {'score': 0},
    presentation: {'icon': 'star', 'color': 0xFFFBC02D},
  ),
  SidebarObject(
    name: 'חיפוש',
    structure: {'type': 'search'},
    behavior: {'onSearch': 'ביצוע חיפוש'},
    data: {'query': ''},
    presentation: {'icon': 'search', 'color': 0xFF1976D2},
  ),
  SidebarObject(
    name: 'קובץ משותף',
    structure: {'type': 'shared_file'},
    behavior: {'onDownload': 'הורדה'},
    data: {'file': ''},
    presentation: {'icon': 'attach_file', 'color': 0xFF607D8B},
  ),
];
