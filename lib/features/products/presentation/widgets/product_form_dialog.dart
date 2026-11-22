import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/api_constants.dart';

import '../../domain/entities/product.dart';
import '../../domain/entities/product_request.dart';

import '../controllers/product_controller.dart';

class ProductFormDialog extends StatefulWidget {
  final Product? product;

  const ProductFormDialog({
    super.key,
    this.product,
  });

  @override
  State<ProductFormDialog> createState() =>
      _ProductFormDialogState();
}

class _ProductFormDialogState
    extends State<ProductFormDialog> {

  final formKey = GlobalKey<FormState>();

  final ProductController controller =
      Get.find<ProductController>();

  final ImagePicker imagePicker = ImagePicker();

  late final TextEditingController nameController;

  late final TextEditingController priceController;

  late final TextEditingController stockController;

  XFile? selectedImage;

  String? imageError;

  bool get isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.product?.name ?? '',
    );

    priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );

    stockController = TextEditingController(
      text: widget.product?.stock.toString() ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();

    super.dispose();
  }

  // PICK IMAGE

  Future<void> pickImage() async {
    final image = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );

    if (image == null) return;

    final extension = image.path
        .split('.')
        .last
        .toLowerCase();

    const allowedExtensions = [
      'jpg',
      'jpeg',
      'png',
      'webp',
      'gif',
    ];

    if (!allowedExtensions.contains(extension)) {
      setState(() {
        imageError = 'Only JPG, PNG, WEBP and GIF are allowed.';
      });

      return;
    }

    final size = await image.length();

    if (size > ApiConstants.imageMaxSize) {
      setState(() {
        imageError = 'Image must be smaller than 2 MB.';
      });

      return;
    }

    setState(() {
      selectedImage = image;
      imageError = null;
    });
  }

  // SUBMIT FORM

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (!isEditing && selectedImage == null) {
      setState(() {
        imageError = 'Please select a product image.';
      });

      return;
    }

    final request = ProductRequest(
      name: nameController.text.trim(),

      price: double.parse(
        priceController.text.trim(),
      ),

      stock: int.parse(
        stockController.text.trim(),
      ),

      imagePath: selectedImage?.path,
    );

    if (isEditing) {
      await controller.editProduct(
        widget.product!.id,
        request,
      );
    } else {
      await controller.addProduct(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        isEditing ? 'Update Product' : 'Create Product',
      ),

      content: SizedBox(
        width: 400,

        child: SingleChildScrollView(
          child: Form(
            key: formKey,

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [

                // IMAGE PREVIEW

                GestureDetector(
                  onTap: pickImage,

                  child: Container(
                    width: double.infinity,
                    height: 160,

                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),

                    clipBehavior: Clip.antiAlias,

                    child: selectedImage != null
                        ? Image.file(
                            File(selectedImage!.path),
                            fit: BoxFit.cover,
                          )
                        : isEditing &&
                                widget.product!.image.isNotEmpty
                            ? Image.network(
                                getProductImageUrl(
                                  widget.product!.image,
                                ),
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) {
                                  return const Icon(
                                    Icons.broken_image,
                                    size: 50,
                                  );
                                },
                              )
                            : const Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,

                                children: [
                                  Icon(
                                    Icons.add_a_photo,
                                    size: 40,
                                  ),

                                  SizedBox(height: 8),

                                  Text('Select Product Image'),
                                ],
                              ),
                  ),
                ),

                if (isEditing)
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text(
                      'Tap the image to replace it. '
                      'Leave unchanged to keep the existing image.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11),
                    ),
                  ),

                if (imageError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),

                    child: Text(
                      imageError!,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // NAME

                TextFormField(
                  controller: nameController,

                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter product name';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // PRICE

                TextFormField(
                  controller: priceController,

                  keyboardType:
                      const TextInputType.numberWithOptions(
                    decimal: true,
                  ),

                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),

                  validator: (value) {
                    final price = double.tryParse(
                      value?.trim() ?? '',
                    );

                    if (price == null || price < 0) {
                      return 'Enter a valid price';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // STOCK

                TextFormField(
                  controller: stockController,

                  keyboardType: TextInputType.number,

                  decoration: const InputDecoration(
                    labelText: 'Stock',
                    border: OutlineInputBorder(),
                  ),

                  validator: (value) {
                    final stock = int.tryParse(
                      value?.trim() ?? '',
                    );

                    if (stock == null || stock < 0) {
                      return 'Enter a valid stock quantity';
                    }

                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      actions: [

        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),

        Obx(() {
          return ElevatedButton(
            onPressed: controller.isSubmitting.value
                ? null
                : submit,

            child: controller.isSubmitting.value
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    isEditing ? 'Update' : 'Create',
                  ),
          );
        }),
      ],
    );
  }
}
