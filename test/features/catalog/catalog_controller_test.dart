import 'package:flutter_core_base/features/catalog/data/repositories/catalog_repository.dart';
import 'package:flutter_core_base/features/catalog/domain/entities/catalog_feature.dart';
import 'package:flutter_core_base/features/catalog/domain/repositories/i_catalog_repository.dart';
import 'package:flutter_core_base/features/catalog/presentation/catalog_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockCatalogRepository extends Mock implements ICatalogRepository {}

void main() {
  group('CatalogController', () {
    late MockCatalogRepository mockRepository;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockCatalogRepository();
    });

    tearDown(() {
      container.dispose();
    });

    test('should fetch and return list of CatalogFeatures on build', () async {
      const mockFeatures = [
        CatalogFeature(
          id: 'test_feature',
          title: 'Test Feature',
          description: 'Description',
          routePath: '/test',
          category: FeatureCategory.data,
          iconKey: CatalogIconKeys.feed,
        ),
      ];

      when(() => mockRepository.getFeatures()).thenAnswer((_) async => const Right(mockFeatures));

      container = ProviderContainer(
        overrides: [
          catalogRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final state = await container.read(catalogControllerProvider.future);

      expect(state.length, 1);
      expect(state.first.id, 'test_feature');
      expect(state.first.title, 'Test Feature');
    });
  });
}
