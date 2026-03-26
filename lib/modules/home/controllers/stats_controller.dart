import 'package:get/get.dart';
import 'package:template/core/mixins/state_handler_mixin.dart';
import 'package:template/modules/home/models/stats_response_model.dart';
import 'package:template/modules/home/services/stats_service.dart';

class StatsController extends GetxController with StateHandlerMixin {
  var isLoading = false.obs;

  var stats = Data(requisitions: 0, deliveries: 0).obs;

  @override
  void onInit() {
    super.onInit();
    fetchStats();
  }

  Future<void> fetchStats() async {
    isLoading(true);

    await StatsService().fetch().then((response) {
      stats.value = response.data;
    }).catchError((error) {
      handleState('error', error.toString());
    }).whenComplete(() => isLoading(false));
  }
}