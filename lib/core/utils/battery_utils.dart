// battery update for system 

import 'package:battery_plus/battery_plus.dart';

class BatteryUtils {
  BatteryUtils._();
  
  static final Battery _battery = Battery();
  
  static Future<String> getBatteryLevel() async {
    try {
      final level = await _battery.batteryLevel;
      return '$level%';
    } catch (e) {
      return 'Unknown';
    }
  }
  
  static Future<String> getBatteryState() async {
    try {
      final state = await _battery.batteryState;
      switch (state) {
        case BatteryState.charging:
          return 'Charging';
        case BatteryState.full:
          return 'Full';
        case BatteryState.discharging:
          return 'Discharging';
        case BatteryState.connectedNotCharging:
          return 'Connected, not charging';
        default:
          return 'Unknown';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
  
  static Future<String> respondToBatteryQuery() async {
    try {
      final level = await _battery.batteryLevel;
      final state = await _battery.batteryState;
      
      String stateText;
      switch (state) {
        case BatteryState.charging:
          stateText = 'charging';
          break;
        case BatteryState.full:
          return 'Your battery is fully charged at 100%! 🔋';
        case BatteryState.discharging:
          stateText = 'discharging';
          break;
        case BatteryState.connectedNotCharging:
          stateText = 'connected but not charging';
          break;
        default:
          stateText = 'in an unknown state';
      }
      
      String emoji = level > 80 ? '🔋' : level > 50 ? '🔋' : level > 20 ? '⚡' : '🪫';
      
      return 'Your battery is at $level% and $stateText. $emoji';
    } catch (e) {
      return 'Sorry, I couldn\'t check your battery status.';
    }
  }
  
  static Stream<BatteryState> get batteryStateStream => _battery.onBatteryStateChanged;
  
  static Future<bool> isCharging() async {
    try {
      final state = await _battery.batteryState;
      return state == BatteryState.charging;
    } catch (e) {
      return false;
    }
  }
  
  static Future<bool> isFull() async {
    try {
      final state = await _battery.batteryState;
      return state == BatteryState.full;
    } catch (e) {
      return false;
    }
  }
  
  static Future<bool> isLowBattery() async {
    try {
      final level = await _battery.batteryLevel;
      return level < 20;
    } catch (e) {
      return false;
    }
  }
  
  static Future<Map<String, dynamic>> getBatteryInfo() async {
    try {
      final level = await _battery.batteryLevel;
      final state = await _battery.batteryState;
      
      return {
        'level': level,
        'state': state.toString().split('.').last,
        'isCharging': state == BatteryState.charging,
        'isFull': state == BatteryState.full,
        'isLow': level < 20,
      };
    } catch (e) {
      return {
        'level': 0,
        'state': 'unknown',
        'isCharging': false,
        'isFull': false,
        'isLow': false,
      };
    }
  }
}
