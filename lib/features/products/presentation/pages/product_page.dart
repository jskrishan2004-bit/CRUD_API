import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_crud/features/products/presentation/pages/product_details_.dialog.dart';

import '../controllers/product_controller.dart';

import '../widgets/product_card.dart';
import '../widgets/product_form_dialog.dart';



class ProductPage extends GetView<ProductController> {
  const ProductPage({super.key});

  void openCreateDialog() {
    Get.dialog(
      const ProductFormDialog(),
    );
  }

  void openEditDialog(product) {
    Get.dialog(
      ProductFormDialog(
        product: product,
      ),
    );
  }

  Future<void> openDetails(String id) async {
    final product = await controller.fetchProductById(id);

    if (product == null) return;

    Get.to(
      () => ProductDetailsPage(
        product: product,
      ),
    );
  }

  void confirmDelete(String id) {
    Get.defaultDialog(
      title: 'Delete Product',

      middleText:
          'Are you sure you want to delete this product?',

      textCancel: 'Cancel',

      textConfirm: 'Delete',

      confirmTextColor: Colors.white,

      onConfirm: () {
        Get.back();

        controller.removeProduct(id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Management'),

        actions: [
          IconButton(
            onPressed: () {
              controller.fetchProducts(refresh: true);
            },

            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: openCreateDialog,

        child: const Icon(Icons.add),
      ),

      body: Obx(() {

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.errorMessage.isNotEmpty &&
            controller.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [

                Text(controller.errorMessage.value),

                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: () {
                    controller.fetchProducts(refresh: true);
                  },

                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.products.isEmpty) {
          return const Center(
            child: Text('No products available'),
          );
        }

        return RefreshIndicator(
          onRefresh: () {
            return controller.fetchProducts(refresh: true);
          },

          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),

            itemCount: controller.products.length + 1,

            itemBuilder: (context, index) {

              if (index == controller.products.length) {

                if (!controller.hasMore) {
                  return const SizedBox(height: 80);
                }

                return Padding(
                  padding: const EdgeInsets.all(16),

                  child: Center(
                    child: ElevatedButton(
                      onPressed: controller.isLoadingMore.value
                          ? null
                          : controller.loadMoreProducts,

                      child: controller.isLoadingMore.value
                          ? const CircularProgressIndicator()
                          : const Text('Load More'),
                    ),
                  ),
                );
              }

              final product = controller.products[index];

              return ProductCard(
                product: product,

                onDetails: () {
                  openDetails(product.id);
                },

                onEdit: () {
                  openEditDialog(product);
                },

                onDelete: () {
                  confirmDelete(product.id);
                },
              );
            },
          ),
        );
      }),
    );
  }
}
