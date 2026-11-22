import '../entities/product.dart';
import '../repositories/product_repository.dart';

class DeleteProduct {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  Future<Product> call(String id) {
    return repository.deleteProduct(id);
  }
}
