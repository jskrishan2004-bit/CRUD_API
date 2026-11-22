import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_crud/features/products/presentation/bindings/product_binding.dart';
import 'package:todo_crud/features/products/presentation/pages/product_page.dart';

import 'features/tasks/presentation/pages/task_page.dart';
import 'features/tasks/presentation/bindings/task_binding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Product CRUD',

      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),

      initialBinding: ProductBinding(),

      home: const ProductPage(),
    );
  }
}
