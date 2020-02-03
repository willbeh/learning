import 'package:firebase_remote_config/firebase_remote_config.dart';

Future<RemoteConfig> getRemoteConfig() async{
  final RemoteConfig remoteConfig = await RemoteConfig.instance;

  final defaults = <String, dynamic>{'home_series_watch': 3};
  await remoteConfig.setDefaults(defaults);

  await remoteConfig.fetch(expiration: const Duration(hours: 5));
  await remoteConfig.activateFetched();
  return remoteConfig;
}