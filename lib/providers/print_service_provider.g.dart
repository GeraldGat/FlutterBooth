// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(printService)
const printServiceProvider = PrintServiceProvider._();

final class PrintServiceProvider
    extends $FunctionalProvider<PrintService, PrintService, PrintService>
    with $Provider<PrintService> {
  const PrintServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'printServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$printServiceHash();

  @$internal
  @override
  $ProviderElement<PrintService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PrintService create(Ref ref) {
    return printService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PrintService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PrintService>(value),
    );
  }
}

String _$printServiceHash() => r'ea491095124a8d83ebc066943399ee1420b16c6b';
