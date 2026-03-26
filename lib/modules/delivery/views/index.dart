import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:template/core/themes/app_theme.dart';
import 'package:template/core/routes/app_routes.dart';
import 'package:template/modules/delivery/controllers/delivery_controller.dart';

class DeliveryPage extends StatelessWidget {
  DeliveryPage({Key? key}) : super(key: key);
  final DeliveryController controller = Get.put(DeliveryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: false,
            pinned: true,
            elevation: 0,
            centerTitle: false,
            backgroundColor: AppColors.card,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back_outlined,
                color: AppColors.text,
              ),
            ),
            title: const Text(
              'Pending Deliveries',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.text
              ),
            ),
          ),

          Obx(() {
            if (controller.isLoading.value) {
              return const SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
                  ),
                ),
              );
            }

            if (controller.orders.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.subduedText.withValues(alpha: 0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                          )
                        ]
                    ),
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              'No Pending Deliveries',
                              style: TextStyle(
                                color: AppColors.subduedText,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              )
                          ),
                          SizedBox(height: 8),
                          Text(
                              'You have no pending deliveries yet. Create a requisition to get started.',
                              style: TextStyle(
                                color: AppColors.subduedText,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              )
                          )
                        ]
                    )
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final orders = controller.orders[index];
                    return _buildLPOCard(context, orders);
                  },
                  childCount: controller.orders.length,
                ),
              ),
            );
          }),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
    );
  }

  Widget _buildLPOCard(BuildContext context, dynamic order) {
    final statusColor = _getStatusColor(order.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.subduedText.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => Get.toNamed(
          AppRoutes.receivables,
          arguments: order,
        ),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row with Status Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.uid.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: AppColors.subduedText.withValues(alpha: 0.7),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '2025-02-09',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.subduedText.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          statusColor.withValues(alpha: 0.15),
                          statusColor.withValues(alpha: 0.08),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.25),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      order.status.toString().toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Info Cards Container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    // Supplier & Branch Info
                    Row(
                      children: [
                        Expanded(
                          child: _buildEnhancedInfoRow(
                            Icons.business_rounded,
                            'Supplier',
                            order.supplier.name.toString(),
                            AppColors.primary,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: AppColors.subduedText.withValues(alpha: 0.15),
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        Expanded(
                          child: _buildEnhancedInfoRow(
                            Icons.store_rounded,
                            'Branch',
                            order.branch.name.toString(),
                            AppColors.accent,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Items Info
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.subduedText.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.inventory_2_rounded,
                              size: 18,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '20 items',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.text.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(
                    AppRoutes.receivables,
                    arguments: order,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.card,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shadowColor: AppColors.accent.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_rounded, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Receive Delivery',
                        style: TextStyle(
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
      ),
    );
  }

  Widget _buildEnhancedInfoRow(
      IconData icon,
      String label,
      String value,
      Color accentColor,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: accentColor.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.subduedText.withValues(alpha: 0.8),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }


  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.secondary;
      case 'approved':
        return AppColors.accent;
      case 'in_transit':
        return AppColors.primary;
      case 'rejected':
        return AppColors.secondary;
      default:
        return AppColors.subduedText;
    }
  }
}