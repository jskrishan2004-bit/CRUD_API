import '../entities/product.dart';
import '../entities/product_request.dart';
import '../repositories/product_repository.dart';

class UpdateProduct {
  final ProductRepository repository;

  UpdateProduct(this.repository);

  Future<Product> call(
    String id,
    ProductRequest request,
  ) {
    return repository.updateProduct(id, request);
  }
}
