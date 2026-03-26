import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:template/core/themes/app_theme.dart';
import 'package:template/core/routes/app_routes.dart';
import 'package:template/modules/requisitions/models/requisition_response.dart';
import 'package:template/modules/requisitions/controllers/fetch_requisition_controller.dart';

class RequisitionsPage extends StatelessWidget {
  RequisitionsPage({Key? key}) : super(key: key);
  final FetchRequisitionController controller = Get.put(FetchRequisitionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: controller.scrollController,
        slivers: [
          // App Bar with Stats
          SliverAppBar(
            floating: false,
            pinned: true,
            elevation: 0,
            centerTitle: false,
            backgroundColor: AppColors.card,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_outlined, color: AppColors.text),
            ),
            title: const Text(
              'Store Requisitions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppColors.text,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(88),
              child: Container(
                color: AppColors.background,
                padding: const EdgeInsets.all(16),
                child: Obx(() => Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Requests',
                        '${controller.pagination.value.total ?? controller.requisitions.length}',
                        Icons.assignment_outlined,
                        AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Pending',
                        '${controller.requisitions.where((r) => r.status?.toLowerCase() == 'pending').length}',
                        Icons.hourglass_empty_rounded,
                        AppColors.secondary,
                      ),
                    ),
                  ],
                )),
              ),
            ),
          ),

          // Content Area
          Obx(() {
            if (controller.isLoading.value && controller.requisitions.isEmpty) {
              return const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
                  ),
                ),
              );
            }

            if (controller.requisitions.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: _buildEmptyState(),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    if (index == controller.requisitions.length) {
                      return _buildLoader();
                    }
                    final requisition = controller.requisitions[index];
                    return _buildRequisitionCard(context, requisition);
                  },
                  childCount: controller.requisitions.length + 1,
                ),
              ),
            );
          }),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () => Get.toNamed(AppRoutes.createRequisition),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Requisition', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(color: AppColors.subduedText, fontSize: 10, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold, height: 1.0),
          ),
        ],
      ),
    );
  }

  Widget _buildRequisitionCard(BuildContext context, Requisition requisition) {
    final statusColor = _getStatusColor(requisition.status ?? 'pending');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.subduedText.withValues(alpha: 0.1)),
      ),
      child: InkWell(
        onTap: () => Get.toNamed(AppRoutes.requisition, arguments: requisition),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        requisition.uid ?? 'N/A',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        requisition.createdAt != null
                            ? DateFormat('MMM dd, yyyy • HH:mm').format(requisition.createdAt!)
                            : 'Date Unknown',
                        style: TextStyle(fontSize: 12, color: AppColors.subduedText.withValues(alpha: 0.8)),
                      ),
                    ],
                  ),
                  _buildStatusBadge(requisition.status ?? 'pending', statusColor),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildInfoCol(Icons.store_rounded, 'Branch', requisition.branch?.name ?? 'N/A', AppColors.primary)),
                        _buildDivider(),
                        Expanded(child: _buildInfoCol(Icons.local_shipping_rounded, 'Supplier', requisition.supplier?.name ?? 'Internal', AppColors.accent)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildItemSummaryRow(requisition.items?.length ?? 0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoCol(IconData icon, String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color.withValues(alpha: 0.7)),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.subduedText, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.text), maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 30, color: AppColors.subduedText.withValues(alpha: 0.15), margin: const EdgeInsets.symmetric(horizontal: 12));
  }

  Widget _buildItemSummaryRow(int count) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.subduedText.withValues(alpha: 0.1))),
      child: Row(
        children: [
          const Icon(Icons.inventory_2_outlined, size: 16, color: AppColors.primary),
          const SizedBox(width: 10),
          Text('$count Items Requested', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildLoader() {
    return Obx(() => controller.isLoadingMore.value
        ? const Padding(padding: EdgeInsets.all(16.0), child: Center(child: CircularProgressIndicator(strokeWidth: 2)))
        : const SizedBox.shrink());
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note_add_outlined, size: 64, color: AppColors.subduedText.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          const Text('No Requisitions Found', style: TextStyle(color: AppColors.subduedText, fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved': return AppColors.accent;
      case 'pending': return AppColors.secondary;
      case 'rejected': return Colors.redAccent;
      case 'delivered': return AppColors.primary;
      default: return AppColors.subduedText;
    }
  }
}