import 'package:flutter/scheduler.dart';
import 'package:template/core/utils/dialog_utility.dart';

mixin StateHandlerMixin {
  void handleState(String state, String message) {
    // This tells Flutter: "Wait until you're done with the current frame/transition,
    // then show this dialog."
    SchedulerBinding.instance.addPostFrameCallback((_) {
      DialogUtility.showDialog(state: state, message: message);
    });
  }
}