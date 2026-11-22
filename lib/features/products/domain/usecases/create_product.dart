import '../entities/product.dart';
import '../entities/product_request.dart';
import '../repositories/product_repository.dart';

class CreateProduct {
  final ProductRepository repository;

  CreateProduct(this.repository);

  Future<Product> call(ProductRequest request) {
    return repository.createProduct(request);
  }
}
