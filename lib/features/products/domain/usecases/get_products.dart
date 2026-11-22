

import '../entities/product_page.dart';
import '../repositories/product_repository.dart';

class GetProducts {
  final ProductRepository repository;

  GetProducts(this.repository);

  Future<ProductPage> call({
    required int page,
    required int limit,
  }) {
    return repository.getProducts(
      page: page,
      limit: limit,
    );
  }
}
