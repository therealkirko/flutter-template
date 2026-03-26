import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:template/core/themes/app_theme.dart';
import 'package:template/core/routes/app_routes.dart';
import 'package:template/modules/auth/controllers/auth_controller.dart';
import 'package:template/modules/home/controllers/stats_controller.dart';
import 'package:template/modules/requisitions/controllers/fetch_requisition_controller.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final authController = Get.find<AuthController>();
  final StatsController statsController = Get.put(StatsController());
  final FetchRequisitionController requisitionController = Get.put(FetchRequisitionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            statsController.fetchStats(),
            requisitionController.fetch(),
          ]);
        },
        child: CustomScrollView(
          slivers: [
            // Header Section
            SliverPadding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 60, bottom: 16),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.subduedText.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            authController.user.value?.name ?? '',
                            style: const TextStyle(
                              fontSize: 26,
                              color: AppColors.text,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('EEEE, MMM d').format(DateTime.now()),
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.subduedText.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.subduedText.withValues(alpha: 0.1),
                        ),
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Key Metrics Overview
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.text,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ),

            // Stats Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: Obx(() {
                  final s = statsController.stats.value;

                  return Column(
                    children: [
                      // Top Row - Primary Metrics
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricCard(
                              label: 'This Month',
                              value: '${s.requisitions ?? 0}',
                              subLabel: 'Requisitions',
                              icon: Icons.shopping_cart_outlined,
                              color: AppColors.primary,
                              trend: '+12%',
                              isPositive: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildMetricCard(
                              label: 'Pending',
                              value: '${s.deliveries ?? 0}',
                              subLabel: 'Deliveries',
                              icon: Icons.local_shipping_outlined,
                              color: AppColors.accent,
                              trend: '3 today',
                              isPositive: null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Bottom Row - Secondary Metrics
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricCard(
                              label: 'Low Stock',
                              value: '0',
                              subLabel: 'Items',
                              icon: Icons.inventory_outlined,
                              color: Colors.orange.shade700,
                              trend: 'Alert',
                              isPositive: false,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildMetricCard(
                              label: 'Total Value',
                              value: '0',
                              subLabel: 'KES',
                              icon: Icons.account_balance_wallet_outlined,
                              color: AppColors.secondary,
                              trend: null,
                              isPositive: null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ),
            ),

            // Quick Actions Section
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.text,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ),

            // Action Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionCard(
                            title: 'New Requisition',
                            icon: Icons.add_shopping_cart,
                            color: AppColors.primary,
                            onTap: () => Get.toNamed(AppRoutes.createRequisition),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildActionCard(
                            title: 'Receive Delivery',
                            icon: Icons.local_shipping,
                            color: AppColors.accent,
                            onTap: () => Get.toNamed(AppRoutes.delivery),
                          ),
                        ),
                      ],
                    ),
                    // const SizedBox(height: 12),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: _buildActionCard(
                    //         title: 'Record Sales',
                    //         icon: Icons.point_of_sale,
                    //         color: AppColors.secondary,
                    //         onTap: () {
                    //           // Add sales route
                    //         },
                    //       ),
                    //     ),
                    //     const SizedBox(width: 12),
                    //     Expanded(
                    //       child: _buildActionCard(
                    //         title: 'View Stock',
                    //         icon: Icons.inventory_2,
                    //         color: Colors.purple.shade700,
                    //         onTap: () {
                    //           // Add stock route
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),

            // Recent Activity Header
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Recent Activity',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.text,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.requisitions),
                      child: const Row(
                        children: [
                          Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Recent Requisitions List (Max 3)
            Obx(() {
              if (requisitionController.isLoading.isTrue) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                );
              }

              if (requisitionController.requisitions.isEmpty) {
                return SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.subduedText.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.inbox_rounded,
                          size: 48,
                          color: AppColors.subduedText.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No Recent Activity',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.subduedText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Your recent requisitions will appear here',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.subduedText,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Show only first 3 requisitions
              final displayRequisitions = requisitionController.requisitions.take(3).toList();

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final requisition = displayRequisitions[index];
                      return _buildCompactRequisitionCard(context, requisition);
                    },
                    childCount: displayRequisitions.length,
                  ),
                ),
              );
            }),

            // Bottom spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }

  // Metric Card Widget (Redesigned for cleaner look)
  Widget _buildMetricCard({
    required String label,
    required String value,
    required String subLabel,
    required IconData icon,
    required Color color,
    String? trend,
    bool? isPositive,
  }) {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPositive == true
                        ? Colors.green.withValues(alpha: 0.1)
                        : isPositive == false
                        ? Colors.red.withValues(alpha: 0.1)
                        : AppColors.subduedText.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      if (isPositive != null)
                        Icon(
                          isPositive
                              ? Icons.trending_up_rounded
                              : Icons.trending_down_rounded,
                          size: 12,
                          color: isPositive ? Colors.green.shade700 : Colors.red.shade700,
                        ),
                      if (isPositive != null) const SizedBox(width: 2),
                      Text(
                        trend,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isPositive == true
                              ? Colors.green.shade700
                              : isPositive == false
                              ? Colors.red.shade700
                              : AppColors.subduedText,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: color,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subLabel,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.subduedText.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.text.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Compact Action Card Widget
  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.subduedText.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Compact Requisition Card (Smaller version for home page)
  Widget _buildCompactRequisitionCard(BuildContext context, dynamic requisition) {
    final statusColor = _getStatusColor(requisition.status ?? 'pending');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.subduedText.withValues(alpha: 0.1),
        ),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to requisition details
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        requisition.uid ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('dd MMM yyyy').format(requisition.date),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.subduedText.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    (requisition.status ?? 'pending').toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.business_rounded,
                  size: 14,
                  color: AppColors.subduedText.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    requisition.supplier?.name ?? 'N/A',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text.withValues(alpha: 0.8),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.inventory_2_rounded,
                  size: 14,
                  color: AppColors.subduedText.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  '${requisition.items?.length ?? 0} items',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.secondary;
      case 'approved':
        return AppColors.accent;
      case 'rejected':
        return Colors.red.shade700;
      case 'converted':
        return AppColors.primary;
      default:
        return AppColors.subduedText;
    }
  }
}