import 'package:flutter_test/flutter_test.dart';
import 'package:flutterbooth/models/print_result.dart';

void main() {
  group('PrintResult', () {
    test('success factory creates successful result', () {
      final result = PrintResult.success();
      expect(result.success, isTrue);
      expect(result.errorMessage, isNull);
      expect(result.jobId, isNull);
    });

    test('success factory with jobId', () {
      final result = PrintResult.success(jobId: 'job-123');
      expect(result.success, isTrue);
      expect(result.jobId, 'job-123');
    });

    test('failure factory creates failed result', () {
      final result = PrintResult.failure('Printer not found');
      expect(result.success, isFalse);
      expect(result.errorMessage, 'Printer not found');
      expect(result.jobId, isNull);
    });

    test('toString for success includes jobId', () {
      final result = PrintResult.success(jobId: 'abc');
      expect(result.toString(), contains('success'));
      expect(result.toString(), contains('abc'));
    });

    test('toString for failure includes error message', () {
      final result = PrintResult.failure('error occurred');
      expect(result.toString(), contains('failure'));
      expect(result.toString(), contains('error occurred'));
    });
  });
}
