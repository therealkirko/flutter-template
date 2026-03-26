import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:template/core/mixins/state_handler_mixin.dart';
import 'package:template/core/routes/app_routes.dart';
import 'package:template/modules/delivery/models/order_response.dart';
import 'package:template/modules/delivery/services/delivery_service.dart';

class ReceivableController extends GetxController with StateHandlerMixin {
  late Order order;

  final isLoading = false.obs;
  final images = <File>[].obs;
  final notesController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final deliveredQty = <String, int>{}.obs;
  final acceptedQty = <String, int>{}.obs;
  final rejectedQty = <String, int>{}.obs;

  final _picker = ImagePicker();

  void init() {
    for (final item in order.items ?? []) {
      deliveredQty[item.id!] = item.quantityOrdered ?? 0;
      acceptedQty[item.id!] = item.quantityOrdered ?? 0;
      rejectedQty[item.id!] = 0;
    }
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }

  // --- Computed ---
  int get totalOrdered => (order.items ?? [])
      .fold<int>(0, (int s, Item i) => s + (i.quantityOrdered ?? 0));

  int get totalDelivered => deliveredQty.values
      .fold<int>(0, (int s, int v) => s + v);

  bool get hasDiscrepancies => totalDelivered != totalOrdered;

  void updateDelivered(String itemId, String value) {
    final qty = int.tryParse(value) ?? 0;
    deliveredQty[itemId] = qty;
    acceptedQty[itemId] = qty;
    rejectedQty[itemId] = 0;
  }

  void updateAccepted(String itemId, String value) {
    final accepted = int.tryParse(value) ?? 0;
    final delivered = deliveredQty[itemId] ?? 0;
    acceptedQty[itemId] = accepted;
    rejectedQty[itemId] = (delivered - accepted).clamp(0, delivered);
  }

  // --- Images ---
  Future<void> takePicture() async {
    final photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (photo != null) images.add(File(photo.path));
  }

  Future<void> pickFromGallery() async {
    final picked = await _picker.pickMultiImage(imageQuality: 80);
    if (picked.isNotEmpty) images.addAll(picked.map((x) => File(x.path)));
  }

  void removeImage(int index) => images.removeAt(index);

  void showImageOptions() {
    Get.bottomSheet(
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                subtitle: const Text('Capture using camera'),
                onTap: () {
                  Get.back();
                  takePicture();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                subtitle: const Text('Select from your photos'),
                onTap: () {
                  Get.back();
                  pickFromGallery();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      backgroundColor: Get.theme.cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  // --- Submit ---
  void onConfirmTapped() {
    if (!formKey.currentState!.validate()) return;
    if (hasDiscrepancies) {
      _showDiscrepancyDialog();
    } else {
      _submit();
    }
  }

  void _showDiscrepancyDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Quantity Discrepancy'),
        content: const Text(
          'Delivered quantities do not match what was ordered. Proceed anyway?',
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Proceed'),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _buildPayload() {
    return {
      "lpo": order.id,
      "branch": order.branch?.id,
      "supplier": order.supplier?.id,
      "notes": notesController.text,
      "has_discrepancy": hasDiscrepancies,
      "items": (order.items ?? []).map((item) {
        final delivered = deliveredQty[item.id!] ?? 0;
        final accepted = acceptedQty[item.id!] ?? 0;
        final rejected = rejectedQty[item.id!] ?? 0;
        return {
          "id": item.id,
          "item": item.item,
          "quantity_ordered": item.quantityOrdered,
          "quantity_delivered": delivered,
          "quantity_accepted": accepted,
          "quantity_rejected": rejected,
          "status": accepted == item.quantityOrdered ? "completed" : "partial",
        };
      }).toList(),
    };
  }

  void _submit() async {
    isLoading(true);

    final payload = _buildPayload();
    await DeliveryService().create(payload).then((value) {
      handleState('success', 'Delivery submitted successfully.');
      Get.offAllNamed(AppRoutes.home);
    }).catchError((error) {
      handleState('error', error.toString());
    }).whenComplete(() => isLoading(false));
  }
}