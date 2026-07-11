import 'package:flutterbooth/services/print_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'print_service_provider.g.dart';

@riverpod
PrintService printService(Ref ref) {
  return PrintService();
}
