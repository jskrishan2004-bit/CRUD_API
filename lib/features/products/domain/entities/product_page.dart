import 'package:todo_crud/features/products/domain/entities/product.dart';


class ProductPage {
  final List<Product> products;
  final int page;
  final int limit;
  final int total;
  final int totalPage;

  const ProductPage({
    required this.products,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPage,
  });
}