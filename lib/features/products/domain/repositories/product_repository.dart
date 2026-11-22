

import '../entities/product.dart';
import '../entities/product_request.dart';
import '../entities/product_page.dart';

abstract class ProductRepository {

  Future<ProductPage> getProducts({
    required int page,
    required int limit,
  });

  Future<Product> getProductById(String id);

  Future<Product> createProduct(
    ProductRequest request,
  );

  Future<Product> updateProduct(
    String id,
    ProductRequest request,
  );

  Future<Product> deleteProduct(String id);
}
