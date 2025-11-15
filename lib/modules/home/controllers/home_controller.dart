import 'package:get/get.dart';

/// Home controller
/// Manages home screen state and logic
class HomeController extends GetxController {
  // Observable state
  final counter = 0.obs;
  final isLoading = false.obs;
  final currentTabIndex = 0.obs;

  // Sample data
  final items = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  /// Load initial data
  Future<void> loadData() async {
    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // TODO: Implement actual data fetching
      items.value = [
        'Item 1',
        'Item 2',
        'Item 3',
        'Item 4',
        'Item 5',
      ];
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Increment counter
  void increment() {
    counter.value++;
  }

  /// Change tab
  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  /// Refresh data
  Future<void> refresh() async {
    await loadData();
  }
}
