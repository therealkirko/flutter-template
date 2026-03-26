import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:template/core/mixins/state_handler_mixin.dart';
import 'package:template/modules/requisitions/models/requisition_response.dart';
import 'package:template/modules/requisitions/services/requisition_service.dart';

class FetchRequisitionController extends GetxController with StateHandlerMixin {
  var isLoading = false.obs;
  var isLoadingMore = false.obs;

  var pagination = Pagination().obs;
  var requisitions = <Requisition>[].obs;

  late ScrollController scrollController;

  @override
  void onInit() {
    fetch();

    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    scrollController.removeListener(_onScroll);
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 50) {
      if (!isLoadingMore.value &&
          pagination.value.lastPage != null &&
          pagination.value.currentPage! < pagination.value.lastPage!
      ) {
        loadMoreRequisitions();
      }
    }
  }

  void loadMoreRequisitions() {
    if (!isLoadingMore.value &&
        pagination.value.lastPage != null &&
        pagination.value.currentPage! < pagination.value.lastPage!
    ) {
      int nextPage = (pagination.value.currentPage!) + 1;
      fetch(nextPage);
    }
  }

  Future<void> fetch([int page = 1]) async {

    if (page == 1) {
      isLoading(true);
      requisitions.clear();
    } else {
      isLoadingMore(true);
    }

    await RequisitionService().fetch(null, page).then((value) {

      if (page == 1) {
        requisitions.value = value.data.requisitions;
      } else {
        requisitions.addAll(value.data.requisitions);
      }

      pagination.value = value.data.pagination ?? Pagination();
    }).catchError((error) {
      handleState('error', error.toString());
    }).whenComplete(() => isLoading(false));
  }
}