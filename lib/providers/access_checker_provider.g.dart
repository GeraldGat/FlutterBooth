// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_checker_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(accessChecker)
const accessCheckerProvider = AccessCheckerProvider._();

final class AccessCheckerProvider
    extends
        $FunctionalProvider<
          AccessCheckerService,
          AccessCheckerService,
          AccessCheckerService
        >
    with $Provider<AccessCheckerService> {
  const AccessCheckerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accessCheckerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accessCheckerHash();

  @$internal
  @override
  $ProviderElement<AccessCheckerService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AccessCheckerService create(Ref ref) {
    return accessChecker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccessCheckerService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccessCheckerService>(value),
    );
  }
}

String _$accessCheckerHash() => r'449d3e0cf24098681fed611cd30da2af81551000';
