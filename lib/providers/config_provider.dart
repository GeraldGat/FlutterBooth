import 'package:flutterbooth/models/app_config.dart';
import 'package:flutterbooth/services/config_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'config_provider.g.dart';

@riverpod
ConfigService configService(Ref ref) {
  return ConfigService();
}

@riverpod
class ConfigNotifier extends _$ConfigNotifier {
  @override
  FutureOr<AppConfig> build() async {
    ConfigService configService = ref.read(configServiceProvider);
    final config = await configService.getConfig();
    state = AsyncData(config);
    return config;
  }

  Future<void> save(AppConfig newConfig) async {
    ConfigService configService = ref.read(configServiceProvider);
    await configService.saveConfig(newConfig);
    state = AsyncData(newConfig);
  }
}
