import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_starter/core/core.dart';

class AppOpenAdHelper {
  static String get adUnitId {
    if (Platform.isAndroid) {
      return kDebugMode
          ? EnvHelper.get('DEV_ANDROID_APP_OPEN_AD_UNIT_ID')
          : EnvHelper.get('PROD_ANDROID_APP_OPEN_AD_UNIT_ID');
    } else if (Platform.isIOS) {
      return kDebugMode
          ? EnvHelper.get('DEV_IOS_APP_OPEN_AD_UNIT_ID')
          : EnvHelper.get('PROD_IOS_APP_OPEN_AD_UNIT_ID');
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
