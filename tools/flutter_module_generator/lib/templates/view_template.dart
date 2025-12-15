class ViewTemplate {
  static String generate(String moduleName, String className, String controllerClass) {
    return '''import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/$moduleName\_controller.dart';

class $className extends GetView<$controllerClass> {
  const $className({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$className'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refresh,
          ),
        ],
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const LoadingWidget(message: 'Loading...');
          }

          return RefreshIndicator(
            onRefresh: controller.refresh,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Welcome card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$className',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'This is the $moduleName module view. Customize this page to fit your needs.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // TODO: Add your content here
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.construction,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Start building your UI here!',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.loadData,
        child: const Icon(Icons.add),
      ),
    );
  }
}
''';
  }
}
