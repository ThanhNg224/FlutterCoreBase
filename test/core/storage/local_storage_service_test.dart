import 'package:flutter_core_base/core/storage/local_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ILocalStorageService storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = LocalStorageService(await SharedPreferences.getInstance());
  });

  group('int', () {
    test('round-trips a value through setInt/getInt', () async {
      expect(await storage.setInt('count', 42), isTrue);
      expect(storage.getInt('count'), 42);
    });

    test('returns null for a key that was never set', () {
      expect(storage.getInt('missing'), isNull);
    });

    test('remove clears a stored int', () async {
      await storage.setInt('count', 1);
      await storage.remove('count');
      expect(storage.getInt('count'), isNull);
    });
  });

  group('stringList', () {
    test('round-trips a value through setStringList/getStringList', () async {
      expect(await storage.setStringList('tags', ['a', 'b']), isTrue);
      expect(storage.getStringList('tags'), ['a', 'b']);
    });

    test('returns null for a key that was never set', () {
      expect(storage.getStringList('missing'), isNull);
    });

    test('remove clears a stored string list', () async {
      await storage.setStringList('tags', ['a']);
      await storage.remove('tags');
      expect(storage.getStringList('tags'), isNull);
    });
  });
}
