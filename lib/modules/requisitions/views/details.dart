import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:template/core/themes/app_theme.dart';
import 'package:template/modules/requisitions/models/requisition_response.dart';

class RequisitionDetailsPage extends StatelessWidget {
  const RequisitionDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // We expect the Requisition object to be passed via Get.arguments
    final Requisition requisition = Get.arguments;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header with Back Button and ID
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.card,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_outlined, color: AppColors.text),
            ),
            title: Text(
              requisition.uid ?? 'Details',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            actions: [
              _buildStatusBadge(requisition.status ?? 'pending'),
              const SizedBox(width: 16),
            ],
          ),

          // Logistical Information Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildHeaderInfo(requisition),
            ),
          ),

          // Items List Header
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'REQUESTED ITEMS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.subduedText,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          // Items List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final item = requisition.items![index];
                  return _buildItemCard(item);
                },
                childCount: requisition.items?.length ?? 0,
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildHeaderInfo(Requisition requisition) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.subduedText.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          _buildDetailRow(Icons.calendar_month, 'Date Requested',
              requisition.createdAt != null ? DateFormat('MMMM dd, yyyy').format(requisition.createdAt!) : 'N/A'),
          const Divider(height: 24),
          _buildDetailRow(Icons.storefront, 'Branch', requisition.branch?.name ?? 'N/A'),
          const Divider(height: 24),
          _buildDetailRow(Icons.local_shipping, 'Supplier/Vendor', requisition.supplier?.name ?? requisition.vendor?.name ?? 'Internal'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.subduedText, fontWeight: FontWeight.w500)),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.text)),
          ],
        ),
      ],
    );
  }

  Widget _buildItemCard(Item item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.subduedText.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name ?? 'Unknown Item',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.text),
                ),
                Text('ID: ${item.id ?? 'N/A'}', style: const TextStyle(fontSize: 11, color: AppColors.subduedText)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Qty Requested', style: TextStyle(fontSize: 10, color: AppColors.subduedText)),
              Text(
                '${item.quantityRequested ?? 0}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
              ),
              if (item.quantityApproved != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Approved: ${item.quantityApproved}',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.accent),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = status.toLowerCase() == 'approved' ? AppColors.accent : AppColors.secondary;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Text(
          status.toUpperCase(),
          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}