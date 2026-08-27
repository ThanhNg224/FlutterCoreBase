import 'package:flutter_core_base/core/errors/failure.dart';
import 'package:flutter_core_base/features/catalog/domain/entities/catalog_feature.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ICatalogRepository {
  Future<Either<Failure, List<CatalogFeature>>> getFeatures();
}
