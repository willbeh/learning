import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:learning/lang/lang.dart';

Future<RemoteConfig> getRemoteConfig() async{
  final RemoteConfig remoteConfig = await RemoteConfig.instance;

  final defaults = <String, dynamic>{
    'home_series_watch': 3,
    'default_language': 'en',
    'home_upcoming': 5,
    'lang_en': translationValue['en'],
    'lang_zh': translationValue['zh']
  };
  await remoteConfig.setDefaults(defaults);

  await remoteConfig.fetch();
  await remoteConfig.activateFetched();
  return remoteConfig;
}

class AppRemoteConfig {
  RemoteConfig remoteConfig;

  static final AppRemoteConfig _singleton = AppRemoteConfig._internal();

  factory AppRemoteConfig() {
    return _singleton;
  }

  AppRemoteConfig._internal();

  Future<RemoteConfig> getRemoteConfig() async{
    remoteConfig = await RemoteConfig.instance;

    final defaults = <String, dynamic>{
      'home_series_watch': 3,
      'default_language': 'en',
      'home_upcoming': 5,
    };
    await remoteConfig.setDefaults(defaults);

    await remoteConfig.fetch(expiration: const Duration(seconds: 0));
    await remoteConfig.activateFetched();
    return remoteConfig;
  }

  void fetchAgain(){
    remoteConfig.activateFetched();
  }
}

AppRemoteConfig appRemoteConfig = AppRemoteConfig();