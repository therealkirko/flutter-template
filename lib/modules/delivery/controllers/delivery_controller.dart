import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:template/core/mixins/state_handler_mixin.dart';
import 'package:template/modules/auth/controllers/auth_controller.dart';
import 'package:template/modules/delivery/models/order_response.dart';
import 'package:template/modules/delivery/services/order_service.dart';

class DeliveryController  extends GetxController with StateHandlerMixin {
  var isLoading = false.obs;
  var isLoadingMore = false.obs;

  var orders = <Order>[].obs;
  var pagination = Pagination().obs;

  final authController = Get.find<AuthController>();

  Timer? _debounce;
  late ScrollController scrollController;

  @override
  void onInit() {
    fetchOrders();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    _debounce?.cancel();
    super.onClose();
  }


  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 50) {
      if (isLoadingMore.value &&
          pagination.value.currentPage != null &&
          pagination.value.lastPage != null &&
          pagination.value.currentPage! < pagination.value.lastPage!
      ) {
        int nextPage = pagination.value.currentPage! + 1;
        fetchOrders(nextPage);
      }
    }
  }

  void fetchOrders([int page = 1]) {
    if (page == 1) {
      orders.clear();
      isLoading(true);
    } else {
      isLoadingMore(true);
    }

    var branch = authController.branch.value?.id;

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      await OrderService().fetch(page, branch).then((value) {
        if (page == 1) {
          orders.value = value.data.orders;
        } else {
          orders.addAll(value.data.orders);
        }

        pagination.value = value.data.pagination!;
      }).catchError((error) {
        handleState('error', error.toString());
      }).whenComplete(() {
        isLoading(false);
        isLoadingMore(false);
      });
    });
  }
}