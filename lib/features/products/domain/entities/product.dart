class Product {
  final String id;
  final String name;
  final double price;
  final int stock;
  final String image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.image,
    this.createdAt,
    this.updatedAt,
  });
}