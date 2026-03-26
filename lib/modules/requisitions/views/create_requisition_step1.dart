import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:template/core/routes/app_routes.dart';
import 'package:template/core/themes/app_theme.dart';
import 'package:template/core/models/product_response.dart';
import 'package:template/modules/auth/controllers/auth_controller.dart';
import 'package:template/modules/requisitions/controllers/requisition_controller.dart';

class CreateRequisitionStep1 extends StatelessWidget {
  CreateRequisitionStep1({super.key});

  final authController = Get.find<AuthController>();
  final controller = Get.put(RequisitionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          // Modern App Bar
          SliverAppBar(
            floating: false,
            pinned: true,
            elevation: 0,
            centerTitle: false,
            backgroundColor: AppColors.card,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.text,
              ),
            ),
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Requisition',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: AppColors.text,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Step 1 of 2',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.subduedText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Progress Bar
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.card,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.subduedText.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Products',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Set Quantities',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.subduedText.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Branch Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.1),
                          AppColors.primary.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.store_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Requisition for',
                                style: TextStyle(
                                  color: AppColors.subduedText.withValues(alpha: 0.8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                authController.branch.value!.name ?? 'Unknown Branch',
                                style: const TextStyle(
                                  color: AppColors.text,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section Header
                  const Text(
                    'Supplier',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Supplier Selection
                  Obx(() {
                    if (controller.supplierLoading.value) {
                      return Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.subduedText.withValues(alpha: 0.1),
                          ),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    }

                    if (controller.suppliers.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.subduedText.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.subduedText.withValues(alpha: 0.6),
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'No suppliers available',
                              style: TextStyle(
                                color: AppColors.subduedText,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: controller.selectedSupplier.value != null
                              ? AppColors.primary.withValues(alpha: 0.3)
                              : AppColors.subduedText.withValues(alpha: 0.1),
                          width: controller.selectedSupplier.value != null ? 1.5 : 1,
                        ),
                      ),
                      child: DropdownButtonFormField<String>(
                        dropdownColor: AppColors.card,
                        initialValue: controller.selectedSupplier.value?.id,
                        decoration: InputDecoration(
                          hintText: 'Select supplier',
                          hintStyle: TextStyle(
                            color: AppColors.subduedText.withValues(alpha: 0.5),
                            fontSize: 14,
                          ),
                          prefixIcon: Container(
                            padding: const EdgeInsets.all(12),
                            child: Icon(
                              Icons.business_rounded,
                              color: controller.selectedSupplier.value != null
                                  ? AppColors.primary
                                  : AppColors.subduedText.withValues(alpha: 0.5),
                              size: 20,
                            ),
                          ),
                          filled: false,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        items: controller.suppliers.map((s) => DropdownMenuItem(
                          value: s.id,
                          child: Text(
                            s.name ?? 'Unknown Supplier',
                            style: const TextStyle(
                              color: AppColors.text,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )).toList(),
                        onChanged: (String? supplierId) {
                          if (supplierId != null) {
                            final supplier = controller.suppliers.firstWhere(
                                  (s) => s.id == supplierId,
                            );
                            controller.selectSupplier(supplier);
                          } else {
                            controller.clearSupplier();
                          }
                        },
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.subduedText.withValues(alpha: 0.6),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Search Bar (when supplier selected)
          Obx(() {
            if (controller.selectedSupplier.value != null) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.subduedText.withValues(alpha: 0.1),
                      ),
                    ),
                    child: TextFormField(
                      controller: controller.searchController,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        filled: false,
                        hintText: 'Search products...',
                        hintStyle: TextStyle(
                          color: AppColors.subduedText.withValues(alpha: 0.5),
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        suffixIcon: controller.searchController.text.isNotEmpty
                            ? IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: AppColors.subduedText.withValues(alpha: 0.6),
                            size: 20,
                          ),
                          onPressed: () {
                            controller.searchController.clear();
                          },
                        )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      onChanged: (value) => controller.searchProducts(value),
                    ),
                  ),
                ),
              );
            }
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          }),

          // Products Header
          Obx(() {
            if (controller.selectedSupplier.value != null) {
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.searchProduct.value.isNotEmpty
                            ? 'Results (${controller.products.length})'
                            : 'Products (${controller.products.length})',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                          letterSpacing: -0.2,
                        ),
                      ),
                      if (controller.selectedProductsCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.accent.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 14,
                                color: AppColors.accent,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${controller.selectedProductsCount}',
                                style: const TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }
            return const SliverToBoxAdapter(child: SizedBox.shrink());
          }),

          // Products List
          Obx(() {
            if (controller.selectedSupplier.value == null) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.business_rounded,
                          size: 48,
                          color: AppColors.primary.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Select a supplier first',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.subduedText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Choose a supplier to view products',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.subduedText.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (controller.productLoading.value && controller.products.isEmpty) {
              return const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
              );
            }

            if (controller.products.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.subduedText.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            controller.searchProduct.value.isNotEmpty
                                ? Icons.search_off_rounded
                                : Icons.inventory_2_rounded,
                            size: 48,
                            color: AppColors.subduedText.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          controller.searchProduct.value.isNotEmpty
                              ? 'No matches found'
                              : 'No products available',
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.subduedText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.searchProduct.value.isNotEmpty
                              ? 'Try a different search term'
                              : 'No products from this supplier',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.subduedText.withValues(alpha: 0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (controller.searchProduct.value.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          TextButton.icon(
                            onPressed: () {
                              controller.searchController.clear();
                            },
                            icon: const Icon(Icons.close_rounded, size: 18),
                            label: const Text('Clear search'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final product = controller.products[index];
                    return Obx(() {
                      final isSelected = controller.isProductSelected(product.id ?? '');
                      return _buildProductCard(product, isSelected);
                    });
                  },
                  childCount: controller.products.length,
                ),
              ),
            );
          }),

          // Loading more indicator
          Obx(() {
            if (controller.isLoadingMore.isTrue) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              );
            }
            return const SliverToBoxAdapter(child: SizedBox(height: 100));
          }),
        ],
      ),
      bottomNavigationBar: Obx(
            () => controller.selectedProductsCount > 0
            ? _buildBottomBar()
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildProductCard(Product product, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? AppColors.accent
              : AppColors.subduedText.withValues(alpha: 0.1),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.toggleProduct(product),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.accent
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.accent
                          : AppColors.subduedText.withValues(alpha: 0.3),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: isSelected
                      ? const Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: AppColors.card,
                  )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name ?? 'Unknown Product',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? AppColors.text
                              : AppColors.text.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.qr_code_rounded,
                            size: 12,
                            color: AppColors.subduedText.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            product.sku ?? 'N/A',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.subduedText.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () => Get.toNamed(AppRoutes.createRequisition2),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.card,
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Continue with ${controller.selectedProductsCount} '
                    '${controller.selectedProductsCount == 1 ? 'product' : 'products'}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}