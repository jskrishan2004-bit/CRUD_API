import 'package:flutter/material.dart';

class ProductRequest {
  final String? name;
  final double? price;
  final int? stock;
  final String? imagePath;

  const ProductRequest({
     this.name,
     this.price,
     this.stock,
     this.imagePath,
  });
}