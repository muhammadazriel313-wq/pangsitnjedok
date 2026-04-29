import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasipangsitnjedok/main.dart';

void main() {
  testWidgets('App loads successfully smoke test', (WidgetTester tester) async {
    // 1. Memerintahkan sistem untuk membuka aplikasi kita
    await tester.pumpWidget(const PangsitNjedogApp());
    
    // 2. Menunggu sebentar sampai aplikasi selesai memuat (loading)
    await tester.pumpAndSettle();

    // 3. Mengecek apakah ada teks 'Dashboard' di layar kita
    expect(find.text('Dashboard'), findsWidgets);
  });
}