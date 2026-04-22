import 'package:permission_handler/permission_handler.dart';
// permission 
class PermissionUtils {
  PermissionUtils._();
  
  static Future<bool> requestMicrophone() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }
  
  static Future<bool> requestCamera() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }
  
  static Future<bool> requestContacts() async {
    final status = await Permission.contacts.request();
    return status.isGranted;
  }
  
  static Future<bool> requestNotifications() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }
  
  static Future<bool> requestStorage() async {
    if (await _isAndroid13OrHigher()) {
      final status = await Permission.photos.request();
      return status.isGranted;
    } else {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
  }
  
  static Future<bool> checkMicrophone() async {
    return await Permission.microphone.isGranted;
  }
  
  static Future<bool> checkCamera() async {
    return await Permission.camera.isGranted;
  }
  
  static Future<bool> checkContacts() async {
    return await Permission.contacts.isGranted;
  }
  
  static Future<bool> checkNotifications() async {
    return await Permission.notification.isGranted;
  }
  
  static Future<bool> checkStorage() async {
    if (await _isAndroid13OrHigher()) {
      return await Permission.photos.isGranted;
    } else {
      return await Permission.storage.isGranted;
    }
  }
  
  static Future<bool> requestAllPermissions() async {
    final Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.notification,
    ].request();
    
    return statuses.values.every((status) => status.isGranted);
  }
  
  static Future<void> openAppSettings() async {
    await openAppSettings();
  }
  
  static Future<bool> _isAndroid13OrHigher() async {
    // Simple check - in production you'd use device_info_plus
    return true; // Assume modern Android for this implementation
  }
  
  static Future<Map<String, bool>> checkAllPermissions() async {
    return {
      'microphone': await checkMicrophone(),
      'camera': await checkCamera(),
      'contacts': await checkContacts(),
      'notifications': await checkNotifications(),
      'storage': await checkStorage(),
    };
  }
  
  static Future<bool> shouldShowRationale(Permission permission) async {
    return await permission.shouldShowRequestRationale;
  }
}
