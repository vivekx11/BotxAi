import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

class IntentLauncher {
  IntentLauncher._();
  
  static final Map<String, String> _appPackages = {
    'instagram': 'com.instagram.android',
    'youtube': 'com.google.android.youtube',
    'whatsapp': 'com.whatsapp',
    'camera': 'com.android.camera',
    'maps': 'com.google.android.apps.maps',
    'chrome': 'com.android.chrome',
    'gmail': 'com.google.android.gm',
    'facebook': 'com.facebook.katana',
    'twitter': 'com.twitter.android',
    'x': 'com.twitter.android',
    'snapchat': 'com.snapchat.android',
    'telegram': 'org.telegram.messenger',
    'spotify': 'com.spotify.music',
    'netflix': 'com.netflix.mediaclient',
    'settings': 'com.android.settings',
    'calculator': 'com.android.calculator2',
    'clock': 'com.android.deskclock',
    'contacts': 'com.android.contacts',
    'files': 'com.google.android.apps.nbu.files',
    'photos': 'com.google.android.apps.photos',
    'play store': 'com.android.vending',
    'playstore': 'com.android.vending',
  };
  
  static Future<String> openApp(String appName) async {
    try {
      final normalizedName = appName.toLowerCase().trim();
      final packageName = _appPackages[normalizedName];
      
      if (packageName == null) {
        return 'Sorry, I don\'t know how to open $appName';
      }
      
      // Try to launch the app
      final intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        package: packageName,
        flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      
      await intent.launch();
      return 'Opening $appName...';
    } catch (e) {
      // If app is not installed, suggest Play Store
      return 'It seems $appName is not installed. Would you like to install it from Play Store?';
    }
  }
  
  static Future<String> openUrl(String url) async {
    try {
      final intent = AndroidIntent(
        action: 'android.intent.action.VIEW',
        data: url,
      );
      await intent.launch();
      return 'Opening link...';
    } catch (e) {
      return 'Could not open the link';
    }
  }
  
  static Future<String> makeCall(String phoneNumber) async {
    try {
      final intent = AndroidIntent(
        action: 'android.intent.action.DIAL',
        data: 'tel:$phoneNumber',
      );
      await intent.launch();
      return 'Opening dialer...';
    } catch (e) {
      return 'Could not open dialer';
    }
  }
  
  static Future<String> sendSMS(String phoneNumber, {String? message}) async {
    try {
      final intent = AndroidIntent(
        action: 'android.intent.action.SENDTO',
        data: 'smsto:$phoneNumber',
        arguments: message != null ? {'sms_body': message} : null,
      );
      await intent.launch();
      return 'Opening messages...';
    } catch (e) {
      return 'Could not open messages';
    }
  }
  
  static Future<String> sendEmail(String email, {String? subject, String? body}) async {
    try {
      final intent = AndroidIntent(
        action: 'android.intent.action.SENDTO',
        data: 'mailto:$email',
        arguments: {
          if (subject != null) 'subject': subject,
          if (body != null) 'body': body,
        },
      );
      await intent.launch();
      return 'Opening email...';
    } catch (e) {
      return 'Could not open email';
    }
  }
  
  static Future<String> openPlayStore(String appName) async {
    try {
      final intent = AndroidIntent(
        action: 'android.intent.action.VIEW',
        data: 'market://search?q=$appName',
      );
      await intent.launch();
      return 'Opening Play Store...';
    } catch (e) {
      return 'Could not open Play Store';
    }
  }
  
  static bool isAppSupported(String appName) {
    return _appPackages.containsKey(appName.toLowerCase().trim());
  }
  
  static List<String> getSupportedApps() {
    return _appPackages.keys.toList();
  }
}
