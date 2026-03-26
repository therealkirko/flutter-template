import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/core/themes/app_theme.dart';
import 'package:template/modules/delivery/controllers/receivable_controller.dart';
import 'package:template/modules/delivery/models/order_response.dart';

class ReceiveDeliveryPage extends StatelessWidget {
  final Order order;

  ReceiveDeliveryPage({Key? key, required this.order}) : super(key: key);

  final ReceivableController c = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Form(
        key: c.formKey,
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: AppColors.card,
              leading: IconButton(
                onPressed: Get.back,
                icon: const Icon(Icons.arrow_back_outlined, color: AppColors.text),
              ),
              title: const Text(
                'Receive Delivery',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.text,
                ),
              ),
            ),

            // Order Info
            SliverToBoxAdapter(child: _buildOrderInfo()),

            // Summary
            SliverToBoxAdapter(
              child: Obx(() => _buildSummary()),
            ),

            // Items Header
            SliverToBoxAdapter(
              child: _buildSectionHeader(
                Icons.inventory_2,
                'Items (${order.items?.length ?? 0})',
              ),
            ),

            // Items List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildItemCard(order.items![index]),
                  childCount: order.items?.length ?? 0,
                ),
              ),
            ),

            // Photos Header
            SliverToBoxAdapter(
              child: Obx(() => Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.photo_camera, size: 20, color: AppColors.text),
                        const SizedBox(width: 8),
                        Text(
                          'Photos (${c.images.length})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: c.showImageOptions,
                      icon: const Icon(Icons.add_photo_alternate, size: 18),
                      label: const Text('Add'),
                      style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                    ),
                  ],
                ),
              )),
            ),

            // Photos Grid
            SliverToBoxAdapter(
              child: Obx(() => Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: c.images.isEmpty
                    ? _buildEmptyPhotos()
                    : _buildPhotosGrid(),
              )),
            ),

            // Notes Header
            SliverToBoxAdapter(
              child: _buildSectionHeader(Icons.note_alt, 'Delivery Notes'),
            ),

            // Notes Field
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                  controller: c.notesController,
                  maxLines: 4,
                  style: const TextStyle(color: AppColors.text),
                  decoration: InputDecoration(
                    hintText: 'Add any notes about the delivery...',
                    hintStyle: TextStyle(
                      color: AppColors.subduedText.withValues(alpha: 0.6),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.subduedText.withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => _buildBottomBar()),
    );
  }

  // --- Order Info ---
  Widget _buildOrderInfo() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.uid ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  (order.status ?? '').toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.business, 'Supplier', order.supplier?.name ?? ''),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.store, 'Branch', order.branch?.name ?? ''),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.calendar_today, 'Date', order.createdAt?.toString() ?? ''),
        ],
      ),
    );
  }

  // --- Summary ---
  Widget _buildSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryItem(
              'Ordered',
              c.totalOrdered.toString(),
              AppColors.primary,
            ),
          ),
          Container(width: 1, height: 40, color: AppColors.background),
          Expanded(
            child: _buildSummaryItem(
              'Delivered',
              c.totalDelivered.toString(),
              c.hasDiscrepancies ? AppColors.secondary : AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }

  // --- Item Card ---
  Widget _buildItemCard(Item item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name ?? '',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'SKU: ${item.sku ?? ''}',
            style: const TextStyle(fontSize: 12, color: AppColors.subduedText),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Ordered
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ordered',
                      style: TextStyle(fontSize: 11, color: AppColors.subduedText),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.quantityOrdered?.toString() ?? '0',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Delivered
              Expanded(
                flex: 2,
                child: _buildQtyField(
                  label: 'Delivered',
                  initialValue: (item.quantityOrdered ?? 0).toString(),
                  onChanged: (v) => c.updateDelivered(item.id!, v),
                ),
              ),
              const SizedBox(width: 12),
              // Accepted
              Expanded(
                flex: 2,
                child: Obx(() => _buildQtyField(
                  label: 'Accepted',
                  initialValue: (c.acceptedQty[item.id!] ?? 0).toString(),
                  onChanged: (v) => c.updateAccepted(item.id!, v),
                )),
              ),
            ],
          ),
          // Rejected — only shown when there's a discrepancy on this item
          Obx(() {
            final rejected = c.rejectedQty[item.id!] ?? 0;
            if (rejected == 0) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  const Icon(Icons.cancel_outlined, size: 14, color: AppColors.secondary),
                  const SizedBox(width: 6),
                  Text(
                    'Rejected: $rejected',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // --- Photos ---
  Widget _buildEmptyPhotos() {
    return InkWell(
      onTap: c.showImageOptions,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.subduedText.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate, size: 48, color: AppColors.subduedText),
              SizedBox(height: 8),
              Text(
                'Tap to add photos',
                style: TextStyle(color: AppColors.subduedText, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotosGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: c.images.length + 1,
      itemBuilder: (context, index) {
        if (index == c.images.length) {
          return InkWell(
            onTap: c.showImageOptions,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: const Icon(Icons.add, color: AppColors.primary, size: 32),
            ),
          );
        }
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                c.images[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: InkWell(
                onTap: () => c.removeImage(index),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: AppColors.card, size: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // --- Bottom Bar ---
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: c.isLoading.value ? null : c.onConfirmTapped,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.card,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              disabledBackgroundColor: AppColors.subduedText,
            ),
            child: c.isLoading.value
                ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(AppColors.card),
              ),
            )
                : const Text(
              'Confirm Delivery',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  // --- Helpers ---
  Widget _buildQtyField({
    required String label,
    required String initialValue,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.subduedText)),
        const SizedBox(height: 4),
        TextFormField(
          initialValue: initialValue,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: AppColors.text),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.subduedText.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.secondary),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.secondary, width: 2),
            ),
            filled: true,
            fillColor: AppColors.background,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Required';
            if (int.tryParse(value) == null) return 'Invalid';
            if (int.parse(value) < 0) return 'Min 0';
            return null;
          },
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.subduedText),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 13, color: AppColors.subduedText),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.subduedText)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.text),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}