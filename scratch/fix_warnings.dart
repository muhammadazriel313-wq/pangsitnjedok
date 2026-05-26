import 'dart:io';

void main() {
  final dir1 = Directory('lib/customer');
  final dir2 = Directory('lib/service');
  
  final List<File> files = [];
  if (dir1.existsSync()) {
    files.addAll(dir1.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart')));
  }
  if (dir2.existsSync()) {
    files.addAll(dir2.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart')));
  }

  for (var file in files) {
    String content = file.readAsStringSync();
    bool modified = false;

    // 1. Fix withOpacity
    final opacityRegex = RegExp(r'\.withOpacity\(([^)]+)\)');
    if (opacityRegex.hasMatch(content)) {
      content = content.replaceAllMapped(opacityRegex, (match) => '.withValues(alpha: ${match.group(1)})');
      modified = true;
    }

    // 2. Fix (_,__,___) to (_, __, ___)
    if (content.contains('(_,__,___)')) {
      content = content.replaceAll('(_,__,___)', '(_, __, ___)');
      modified = true;
    }

    // 3. Fix avoid_print in lib/service/api_service.dart and lib/service/cart_service.dart
    // Actually, maybe we can replace print( with debugPrint(
    if (file.path.contains('api_service.dart') || file.path.contains('cart_service.dart') || file.path.contains('edit_profil_customer.dart') || file.path.contains('halaman_menu.dart')) {
      final printRegex = RegExp(r'\bprint\(');
      if (printRegex.hasMatch(content)) {
        content = content.replaceAll(printRegex, 'debugPrint(');
        if (!content.contains('import \'package:flutter/foundation.dart\';')) {
          content = "import 'package:flutter/foundation.dart';\n$content";
        }
        modified = true;
      }
    }

    if (modified) {
      file.writeAsStringSync(content);
    }
  }
  stdout.write("Fixes applied.\n");
}
