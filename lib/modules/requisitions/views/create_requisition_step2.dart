import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:template/core/themes/app_theme.dart';
import 'package:template/core/models/product_response.dart';
import 'package:template/modules/auth/controllers/auth_controller.dart';
import 'package:template/modules/requisitions/controllers/requisition_controller.dart';

class CreateRequisitionStep2 extends StatelessWidget {
  CreateRequisitionStep2({super.key});

  final _formKey = GlobalKey<FormState>();
  final authController = Get.find<AuthController>();
  final controller = Get.find<RequisitionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            // Modern App Bar
            SliverAppBar(
              floating: false,
              pinned: true,
              elevation: 0,
              centerTitle: false,
              backgroundColor: AppColors.card,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.text,
                ),
              ),
              title: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Set Quantities',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: AppColors.text,
                      letterSpacing: -0.3,
                    ),
                  ),
                  Text(
                    'Step 2 of 2',
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
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              size: 16,
                              color: AppColors.accent,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Products Selected',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.accent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Set Quantities',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
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
                    // Summary Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.subduedText.withValues(alpha: 0.1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Requisition Summary',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildCompactSummaryItem(
                                  Icons.store_rounded,
                                  'Branch',
                                  authController.branch.value?.name ?? 'Unknown',
                                  AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildCompactSummaryItem(
                                  Icons.business_rounded,
                                  'Supplier',
                                  controller.selectedSupplierName ?? 'Unknown',
                                  AppColors.accent,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Obx(() => _buildCompactSummaryItem(
                            Icons.shopping_bag_rounded,
                            'Products',
                            '${controller.selectedProductsCount} items',
                            AppColors.secondary,
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Total Items Counter
                    Obx(() => Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.accent.withValues(alpha: 0.15),
                            AppColors.accent.withValues(alpha: 0.08),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.shopping_cart_rounded,
                              color: AppColors.accent,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Quantity',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.text.withValues(alpha: 0.7),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${controller.totalItems} items',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.accent,
                                    height: 1.0,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                    const SizedBox(height: 24),

                    // Section Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Product Quantities',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Products with Quantity Inputs
            Obx(() => SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final product = controller.selectedProductsList[index];
                    return _buildProductQuantityCard(product);
                  },
                  childCount: controller.selectedProductsCount,
                ),
              ),
            )),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildProductQuantityCard(Product product) {
    return Obx(() {
      final qty = controller.getQuantity(product.id!);
      final specs = controller.getSpecifications(product.id!) ?? '';

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: qty > 0
                ? AppColors.accent.withValues(alpha: 0.2)
                : AppColors.subduedText.withValues(alpha: 0.1),
            width: qty > 0 ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Info
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
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
            const SizedBox(height: 16),

            // Quantity Controls
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  // Decrement Button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: qty > 0
                          ? () => controller.decrementQuantity(product.id!)
                          : null,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: qty > 0
                              ? AppColors.card
                              : AppColors.subduedText.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: qty > 0
                                ? AppColors.subduedText.withValues(alpha: 0.2)
                                : AppColors.subduedText.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Icon(
                          Icons.remove_rounded,
                          size: 20,
                          color: qty > 0
                              ? AppColors.text
                              : AppColors.subduedText.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                  ),

                  // Quantity Display
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: qty > 0
                            ? AppColors.accent.withValues(alpha: 0.1)
                            : AppColors.card,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: qty > 0
                              ? AppColors.accent.withValues(alpha: 0.3)
                              : AppColors.subduedText.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Text(
                        qty.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: qty > 0 ? AppColors.accent : AppColors.text,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),

                  // Increment Button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => controller.incrementQuantity(product.id!),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.accent,
                              AppColors.accent.withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          size: 20,
                          color: AppColors.card,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Specifications Section
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.description_outlined,
                  size: 14,
                  color: AppColors.subduedText.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 6),
                Text(
                  'Specifications (Optional)',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.subduedText.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.subduedText.withValues(alpha: 0.1),
                ),
              ),
              child: TextField(
                maxLines: 3,
                minLines: 2,
                controller: TextEditingController(text: specs)
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: specs.length),
                  ),
                onChanged: (value) =>
                    controller.setSpecifications(product.id!, value),
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 13,
                  height: 1.4,
                ),
                decoration: InputDecoration(
                  filled: false,
                  hintText: 'e.g., Color: Blue, Size: Large, Material: Cotton',
                  hintStyle: TextStyle(
                    color: AppColors.subduedText.withValues(alpha: 0.4),
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCompactSummaryItem(
      IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              size: 14,
              color: color,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.subduedText.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Obx(() {
      final isBusy =
          controller.isLoading.isTrue || controller.isSubmitting.value;
      final hasItems = controller.totalItems > 0;

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Quick Stats
              if (hasItems)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        size: 16,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${controller.totalItems} items ready • ${controller.selectedProductsCount} products',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: isBusy
                    ? const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary),
                  ),
                )
                    : ElevatedButton(
                  onPressed: hasItems
                      ? () => controller.createRequisition(
                      authController.branch.value?.id.toString())
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.card,
                    padding:
                    const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor:
                    AppColors.subduedText.withValues(alpha: 0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        hasItems
                            ? 'Create Requisition'
                            : 'Add Quantities to Continue',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}