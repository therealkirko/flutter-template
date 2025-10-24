import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

/// Connectivity service for monitoring internet connection
class ConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  // Observable state
  final isConnected = true.obs;
  final connectionType = Rx<ConnectivityResult>(ConnectivityResult.none);

  /// Initialize connectivity service
  Future<ConnectivityService> init() async {
    // Check initial connectivity status
    await checkConnectivity();

    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    });

    return this;
  }

  /// Check current connectivity status
  Future<void> checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
    } catch (e) {
      print('Error checking connectivity: $e');
      isConnected.value = false;
    }
  }

  /// Update connection status based on connectivity result
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    if (results.isEmpty) {
      isConnected.value = false;
      connectionType.value = ConnectivityResult.none;
      return;
    }

    // Get the first result (primary connection)
    final result = results.first;
    connectionType.value = result;

    // Update connection status
    // Consider mobile, wifi, ethernet, and vpn as connected
    isConnected.value = result != ConnectivityResult.none;

    // Log connection changes
    if (isConnected.value) {
      print('✅ Connected via ${_getConnectionTypeName(result)}');
    } else {
      print('❌ No internet connection');
    }
  }

  /// Get human-readable connection type name
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

  /// Get connection type display name
  String get connectionTypeName =>
      _getConnectionTypeName(connectionType.value);

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
