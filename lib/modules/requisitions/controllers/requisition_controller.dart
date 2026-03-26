import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:template/core/routes/app_routes.dart';
import 'package:template/core/models/product_response.dart';
import 'package:template/core/models/supplier_response.dart';
import 'package:template/core/services/product_service.dart';
import 'package:template/core/services/supplier_service.dart';
import 'package:template/core/mixins/state_handler_mixin.dart';
import 'package:template/modules/requisitions/services/requisition_service.dart';

class RequisitionController extends GetxController with StateHandlerMixin {
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final isLoadingMore = false.obs;
  final productLoading = false.obs;
  final supplierLoading = false.obs;

  var searchProduct = ''.obs;

  var products = <Product>[].obs;
  var suppliers = <Supplier>[].obs;
  var allProducts = <Product>[].obs;
  var selectedSupplier = Rxn<Supplier>();
  var productPagination = Pagination().obs;

  final RxMap<String, String> productSpecifications = <String, String>{}.obs;

  var selectedProducts = <String, Product>{}.obs;

  // Quantities: productId -> qty (defaults to 1 when product is selected)
  var quantities = <String, int>{}.obs;

  Timer? _debounce;
  late ScrollController scrollController;
  late TextEditingController searchController;

  @override
  void onInit() {
    fetchSuppliers();

    scrollController = ScrollController();
    searchController = TextEditingController();

    scrollController.addListener(_onScroll);
    super.onInit();
  }

  @override
  void onClose() {
    _debounce?.cancel();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    searchController.dispose();

    products.clear();
    suppliers.clear();
    selectedProducts.clear();
    allProducts.clear();
    quantities.clear();
    selectedSupplier.value = null;
    productPagination.value = Pagination();

    supplierLoading.value = false;
    productLoading.value = false;
    isLoadingMore.value = false;
    isSubmitting.value = false;
    isLoading.value = false;

    searchProduct.value = '';

    super.onClose();
  }

  // ─── Supplier Methods ──────────────────────────────────────────────

  void selectSupplier(Supplier supplier) {
    selectedSupplier.value = supplier;
    selectedProducts.clear();
    quantities.clear();

    fetchSupplierProducts();
  }

  String? get selectedSupplierId => selectedSupplier.value?.id;
  String? get selectedSupplierName => selectedSupplier.value?.name;

  void clearSupplier() {
    selectedSupplier.value = null;
    products.clear();
    allProducts.clear();
    selectedProducts.clear();
    quantities.clear();
    searchProduct.value = '';
    searchController.clear();
    productPagination.value = Pagination();
  }

  void clearData() {
    products.clear();
    isLoading.value = false;
    isSubmitting.value = false;
    productLoading.value = false;
    supplierLoading.value = false;
    productSpecifications.clear();
    isLoadingMore.value = false;

    clearSelectedProducts();
    clearSupplier();
  }

  // ─── Product Selection ─────────────────────────────────────────────

  bool isProductSelected(String productId) {
    return selectedProducts.containsKey(productId);
  }

  void toggleProduct(Product product) {
    if (product.id == null) return;

    if (selectedProducts.containsKey(product.id)) {
      selectedProducts.remove(product.id);
      quantities.remove(product.id);
    } else {
      selectedProducts[product.id!] = product;
      quantities[product.id!] = 1; // default qty
    }

    selectedProducts.refresh();
    quantities.refresh();
  }

  void removeProduct(String productId) {
    selectedProducts.remove(productId);
    quantities.remove(productId);
    selectedProducts.refresh();
    quantities.refresh();
  }

  void clearSelectedProducts() {
    selectedProducts.clear();
    quantities.clear();
  }

  List<Product> get selectedProductsList => selectedProducts.values.toList();
  int get selectedProductsCount => selectedProducts.length;

  // ─── Quantity Methods ──────────────────────────────────────────────

  int getQuantity(String productId) => quantities[productId] ?? 1;

  void incrementQuantity(String productId) {
    quantities[productId] = (quantities[productId] ?? 1) + 1;
    quantities.refresh();
  }

  void decrementQuantity(String productId) {
    final current = quantities[productId] ?? 1;
    if (current > 1) {
      quantities[productId] = current - 1;
      quantities.refresh();
    }
  }

  void setQuantity(String productId, int value) {
    if (value > 0) {
      quantities[productId] = value;
      quantities.refresh();
    }
  }

  String? getSpecifications(String productId) {
    return productSpecifications[productId];
  }

  void setSpecifications(String productId, String specs) {
    if (specs.trim().isEmpty) {
      productSpecifications.remove(productId);
    } else {
      productSpecifications[productId] = specs;
    }
  }

  int get totalItems => quantities.values.fold(0, (sum, qty) => sum + qty);

  // ─── Fetch Methods ─────────────────────────────────────────────────

  void fetchSuppliers() async {
    supplierLoading(true);

    await SupplierService().fetch().then((value) {
      suppliers.value = value.data.suppliers!;
    }).catchError((error) {
      handleState('error', error.message);
    }).whenComplete(() => supplierLoading(false));
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 50) {
      if (!isLoadingMore.value && productPagination.value.currentPage! < productPagination.value.lastPage!) {
        int nextPage = productPagination.value.currentPage! + 1;
        String? currentSearch = searchProduct.value.isEmpty ? null : searchProduct.value;

        debugPrint("Scrolling to page $nextPage");
        fetchSupplierProducts(currentSearch, nextPage);
      }
    }
  }

  void searchProducts(String query) {
    searchProduct.value = query;

    if (query.trim().isEmpty) {
      products.value = allProducts;
    }

    fetchSupplierProducts(query.trim(), 1);
  }

  void loadMoreProducts() {
    if (!isLoadingMore.value && productPagination.value.currentPage! < productPagination.value.lastPage!) {
      int nextPage = (productPagination.value.currentPage!) + 1;
      String? currentSearch = searchProduct.value.isEmpty ? null : searchProduct.value;
      fetchSupplierProducts(currentSearch, nextPage);
    }
  }

  void fetchSupplierProducts([String? search, int page = 1]) async {
    if (selectedSupplier.value?.id == null) return;

    if (page == 1) {
      products.clear();
      (search == null || search.isEmpty) ? allProducts.clear() : null;
      isLoading(true);
    } else {
      isLoadingMore(true);
    }

    debugPrint("Supplier: ${selectedSupplier.value?.id}");

    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      await ProductService().fetch(selectedSupplier.value?.id, search, page).then((value) {
        if (page == 1) {
          products.value = value.data.products!;
          if (search == null || searchProduct.isEmpty) {
            allProducts.addAll(value.data.products!);
          }
        } else {
          products.addAll(value.data.products!);
          if (search == null || searchProduct.isEmpty) {
            allProducts.addAll(value.data.products!);
          }
        }

        productPagination.value = value.data.pagination!;
      }).catchError((error) {
        handleState('error', error.message);
      }).whenComplete(() {
        isLoading(false);
        isLoadingMore(false);
      });
    });
  }

  Future<void> createRequisition(dynamic branchId) async {
    // Guard: nothing to submit
    if (selectedProducts.isEmpty || selectedSupplier.value == null) return;

    isLoading.value = true;      // ← was missing
    isSubmitting.value = true;   // ← was missing

    try {
      final List<Map<String, dynamic>> requisitionItems = [];

      selectedProducts.forEach((productId, product) {
        final int quantity = quantities[productId] ?? 1;
        final String? specs = productSpecifications[productId];

        requisitionItems.add({
          'product_id': productId,
          'quantity': quantity,
          if (specs != null && specs.trim().isNotEmpty)
            'specifications': specs.trim(),
        });
      });

      await RequisitionService().create(selectedSupplier.value!.id, branchId, requisitionItems);

      handleState('success', 'Requisition created successfully');
      Get.offAllNamed(AppRoutes.home);
    } catch (error) {
      handleState('error', error.toString());
    } finally {
      isLoading.value = false;    // ← always resets, even on error
      isSubmitting.value = false;
    }
  }
}