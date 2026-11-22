import 'package:get/get.dart';

import '../../domain/entities/product.dart';
import '../../domain/entities/product_request.dart';

import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/get_product_by_id.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/update_product.dart';
import '../../domain/usecases/delete_product.dart';

class ProductController extends GetxController {

  final GetProducts getProducts;
  final GetProductById getProductById;
  final CreateProduct createProduct;
  final UpdateProduct updateProduct;
  final DeleteProduct deleteProduct;

  ProductController({
    required this.getProducts,
    required this.getProductById,
    required this.createProduct,
    required this.updateProduct,
    required this.deleteProduct,
  });

  // Reactive state

  final RxList<Product> products = <Product>[].obs;

  final RxBool isLoading = false.obs;

  final RxBool isSubmitting = false.obs;

  final RxBool isLoadingMore = false.obs;

  final RxString errorMessage = ''.obs;

  final Rxn<Product> selectedProduct = Rxn<Product>();

  // Pagination

  int currentPage = 1;

  int limit = 10;

  int totalPage = 1;

  bool get hasMore => currentPage < totalPage;

  @override
  void onInit() {
    super.onInit();

    fetchProducts();
  }

  // GET PRODUCTS

  Future<void> fetchProducts({
    bool refresh = false,
  }) async {
    if (isLoading.value) return;

    if (refresh) {
      currentPage = 1;
    }

    try {
      isLoading.value = true;

      errorMessage.value = '';

      final result = await getProducts(
        page: currentPage,
        limit: limit,
      );

      products.assignAll(result.products);

      currentPage = result.page;

      totalPage = result.totalPage;

    } catch (e) {
      errorMessage.value = e.toString();

    } finally {
      isLoading.value = false;
    }
  }

  // LOAD MORE

  Future<void> loadMoreProducts() async {
    if (!hasMore ||
        isLoadingMore.value ||
        isLoading.value) {
      return;
    }

    try {
      isLoadingMore.value = true;

      final nextPage = currentPage + 1;

      final result = await getProducts(
        page: nextPage,
        limit: limit,
      );

      products.addAll(result.products);

      currentPage = result.page;

      totalPage = result.totalPage;

    } catch (e) {
      Get.snackbar('Error', e.toString());

    } finally {
      isLoadingMore.value = false;
    }
  }

  // GET PRODUCT DETAILS

  Future<Product?> fetchProductById(String id) async {
    try {
      final product = await getProductById(id);

      selectedProduct.value = product;

      return product;

    } catch (e) {
      Get.snackbar('Error', e.toString());

      return null;
    }
  }

  // CREATE PRODUCT

  Future<bool> addProduct(ProductRequest request) async {
    try {
      isSubmitting.value = true;

      await createProduct(request);

      Get.back();

      Get.snackbar(
        'Success',
        'Product created successfully',
      );

      await fetchProducts(refresh: true);

      return true;

    } catch (e) {
      Get.snackbar('Error', e.toString());

      return false;

    } finally {
      isSubmitting.value = false;
    }
  }

  // UPDATE PRODUCT

  Future<bool> editProduct(
    String id,
    ProductRequest request,
  ) async {
    try {
      isSubmitting.value = true;

      await updateProduct(id, request);

      Get.back();

      Get.snackbar(
        'Success',
        'Product updated successfully',
      );

      await fetchProducts(refresh: true);

      return true;

    } catch (e) {
      Get.snackbar('Error', e.toString());

      return false;

    } finally {
      isSubmitting.value = false;
    }
  }

  // DELETE PRODUCT

  Future<void> removeProduct(String id) async {
    try {
      await deleteProduct(id);

      products.removeWhere(
        (product) => product.id == id,
      );

      Get.snackbar(
        'Success',
        'Product deleted successfully',
      );

      if (products.isEmpty && currentPage > 1) {
        currentPage--;

        await fetchProducts();
      }

    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
