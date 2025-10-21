// lib/providers/config_provider.dart
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
    final service = ref.watch(configServiceProvider);
    final config = await service.getConfig();
    return config;
  }

  Future<void> reload() async {
    final service = ref.read(configServiceProvider);
    final newConfig = await service.loadConfig(forceReload: true);
    if (newConfig != null) {
      state = AsyncData(newConfig);
    }
  }

  Future<void> save(AppConfig newConfig) async {
    final service = ref.read(configServiceProvider);
    await service.saveConfig(newConfig);
    state = AsyncData(newConfig);
  }
}
