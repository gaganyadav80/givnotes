import 'package:flutter/services.dart';
import 'dart:async';

//TODO not working @Gagan
class MoveToBackground {
  /// The method channel used to contact the native side
  static const MethodChannel _channel = const MethodChannel('move_to_background');

  /// Calls the platform-specific function to send the app to the background
  static Future<void> moveTaskToBack() async {
    await _channel.invokeMethod('moveTaskToBack');
  }
}
