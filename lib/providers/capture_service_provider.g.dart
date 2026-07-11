// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capture_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(captureService)
const captureServiceProvider = CaptureServiceFamily._();

final class CaptureServiceProvider
    extends $FunctionalProvider<CaptureService, CaptureService, CaptureService>
    with $Provider<CaptureService> {
  const CaptureServiceProvider._({
    required CaptureServiceFamily super.from,
    required ({String tempFolderPath, String? gphotoPort}) super.argument,
  }) : super(
         retry: null,
         name: r'captureServiceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$captureServiceHash();

  @override
  String toString() {
    return r'captureServiceProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<CaptureService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CaptureService create(Ref ref) {
    final argument =
        this.argument as ({String tempFolderPath, String? gphotoPort});
    return captureService(
      ref,
      tempFolderPath: argument.tempFolderPath,
      gphotoPort: argument.gphotoPort,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CaptureService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CaptureService>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CaptureServiceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$captureServiceHash() => r'46d567dc851424b0d7b4776949b3586fce50c3f7';

final class CaptureServiceFamily extends $Family
    with
        $FunctionalFamilyOverride<
          CaptureService,
          ({String tempFolderPath, String? gphotoPort})
        > {
  const CaptureServiceFamily._()
    : super(
        retry: null,
        name: r'captureServiceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CaptureServiceProvider call({
    required String tempFolderPath,
    String? gphotoPort,
  }) => CaptureServiceProvider._(
    argument: (tempFolderPath: tempFolderPath, gphotoPort: gphotoPort),
    from: this,
  );

  @override
  String toString() => r'captureServiceProvider';
}
