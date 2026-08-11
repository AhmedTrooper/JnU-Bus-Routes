import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:jnu_bus_routes/main.dart';
import 'package:jnu_bus_routes/core/database/hive_service.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final tempDir = await Directory.systemTemp.createTemp('jnu_bus_test_');
    Hive.init(tempDir.path);
    await Hive.openBox(HiveService.settingsBoxName);
    await Hive.openBox(HiveService.favoritesBoxName);
    await Hive.openBox(HiveService.searchHistoryBoxName);
  });

  testWidgets('JnUBusApp renders successfully', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: JnUBusApp(),
      ),
    );

    expect(find.byType(JnUBusApp), findsOneWidget);
  });
}
