// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(configService)
const configServiceProvider = ConfigServiceProvider._();

final class ConfigServiceProvider
    extends $FunctionalProvider<ConfigService, ConfigService, ConfigService>
    with $Provider<ConfigService> {
  const ConfigServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'configServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$configServiceHash();

  @$internal
  @override
  $ProviderElement<ConfigService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ConfigService create(Ref ref) {
    return configService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConfigService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConfigService>(value),
    );
  }
}

String _$configServiceHash() => r'0530c74134d53050ce4bde30787e50975e0c10b4';

@ProviderFor(ConfigNotifier)
const configProvider = ConfigNotifierProvider._();

final class ConfigNotifierProvider
    extends $AsyncNotifierProvider<ConfigNotifier, AppConfig> {
  const ConfigNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'configProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$configNotifierHash();

  @$internal
  @override
  ConfigNotifier create() => ConfigNotifier();
}

String _$configNotifierHash() => r'1a70c0b9ddc90493bf80d73ad88f32911083045a';

abstract class _$ConfigNotifier extends $AsyncNotifier<AppConfig> {
  FutureOr<AppConfig> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<AppConfig>, AppConfig>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppConfig>, AppConfig>,
              AsyncValue<AppConfig>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
