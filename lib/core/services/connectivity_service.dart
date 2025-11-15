import 'dart:async';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  // Observable state
  final isConnected = true.obs;
  final connectionType = Rx<ConnectivityResult>(ConnectivityResult.none);

  /// Initialize connectivity service
  Future<ConnectivityService> init() async {
    // Check initial connectivity status
    await checkConnectivity();

    // Listen to connectivity changes
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          _updateConnectionStatus(result);
        });

    return this;
  }

  /// Check current connectivity status
  Future<void> checkConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      print('Error checking connectivity: $e');
      isConnected.value = false;
    }
  }

  /// Update connection status based on connectivity result
  void _updateConnectionStatus(ConnectivityResult result) {
    connectionType.value = result;
    isConnected.value = result != ConnectivityResult.none;

    if (isConnected.value) {
      print('✅ Connected via ${_getConnectionTypeName(result)}');
    } else {
      print('❌ No internet connection');
    }
  }

  String _getConnectionTypeName(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.other:
        return 'Other';
      case ConnectivityResult.none:
      default:
        return 'None';
    }
  }

  String get connectionTypeName => _getConnectionTypeName(connectionType.value);

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
