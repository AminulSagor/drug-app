import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddListController extends GetxController {
  /// SEARCH
  final searchCtrl = TextEditingController();
  final isSearching = false.obs;

  /// PRODUCT STATE
  final selectedProduct = Rxn<ProductModel>();

  /// ALL PRODUCTS (MOCK / API later)
  final products = <ProductModel>[
    ProductModel(name: 'Cap. Sergel 20 mg', price: 7, company: 'Healthcare Pharmaceuticals Ltd.'),
    ProductModel(name: 'Cap. Sergel 40 mg', price: 11, company: 'Healthcare Pharmaceuticals Ltd.'),
    ProductModel(name: 'IV. Sergel 40 mg/vial', price: 100, company: 'Healthcare Pharmaceuticals Ltd.'),
    ProductModel(name: 'Tab. Sergel 20 mg', price: 7, company: 'Healthcare Pharmaceuticals Ltd.'),
    ProductModel(name: 'Cap. Seclo 20 mg', price: 6, company: 'Square Pharmaceuticals Ltd.'),
    ProductModel(name: 'Cap. Seclo 40 mg', price: 10, company: 'Square Pharmaceuticals Ltd.'),
    ProductModel(name: 'Tab. Napa 500 mg', price: 2, company: 'Beximco Pharmaceuticals Ltd.'),
    ProductModel(name: 'Tab. Napa Extra', price: 3, company: 'Beximco Pharmaceuticals Ltd.'),
    ProductModel(name: 'Tab. Ace 500 mg', price: 2, company: 'Square Pharmaceuticals Ltd.'),
    ProductModel(name: 'Tab. Ace Plus', price: 3, company: 'Square Pharmaceuticals Ltd.'),
    ProductModel(name: 'Syrup Napa 120 ml', price: 35, company: 'Beximco Pharmaceuticals Ltd.'),
    ProductModel(name: 'Tab. Fexo 120 mg', price: 12, company: 'Incepta Pharmaceuticals Ltd.'),
    ProductModel(name: 'Tab. Fexo 180 mg', price: 18, company: 'Incepta Pharmaceuticals Ltd.'),
    ProductModel(name: 'Cap. Losectil 20 mg', price: 6, company: 'Incepta Pharmaceuticals Ltd.'),
    ProductModel(name: 'Cap. Losectil 40 mg', price: 10, company: 'Incepta Pharmaceuticals Ltd.'),
    ProductModel(name: 'Tab. Monas 10 mg', price: 15, company: 'Renata Limited'),
    ProductModel(name: 'Tab. Monas 5 mg', price: 10, company: 'Renata Limited'),
    ProductModel(name: 'Cap. Pantonix 20 mg', price: 8, company: 'ACI Limited'),
    ProductModel(name: 'Cap. Pantonix 40 mg', price: 12, company: 'ACI Limited'),
    ProductModel(name: 'Syrup Histacin 100 ml', price: 45, company: 'Eskayef Pharmaceuticals Ltd.'),
  ];

  /// 🔍 FILTERED RESULTS (USED BY SUGGESTION LIST)
  final filteredProducts = <ProductModel>[].obs;

  /// 🔑 SEARCH HANDLER (FINAL & CORRECT)
  void onSearchChanged(String value) {
    final query = value.trim().toLowerCase();

    if (query.isEmpty) {
      isSearching.value = false;
      filteredProducts.clear();
      return;
    }

    filteredProducts.value = products
        .where((p) => p.name.toLowerCase().contains(query))
        .toList();

    // ✅ IMPORTANT: always true while typing
    isSearching.value = true;
  }



  /// 🔑 PRODUCT SELECT
  void selectProduct(ProductModel product) {
    selectedProduct.value = product;

    /// close suggestion overlay
    isSearching.value = false;
    filteredProducts.clear();

    /// clear search field
    searchCtrl.clear();
  }

  @override
  void onClose() {
    searchCtrl.dispose();
    super.onClose();
  }
}

/// SIMPLE MODEL
class ProductModel {
  final String name;
  final int price;
  final String? company;

  ProductModel({
    required this.name,
    required this.price,
    this.company,
  });
}
