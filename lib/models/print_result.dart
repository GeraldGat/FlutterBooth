class PrintResult {
  final bool success;
  final String? errorMessage;
  final String? jobId;

  const PrintResult._({
    required this.success,
    this.errorMessage,
    this.jobId,
  });

  factory PrintResult.success({String? jobId}) =>
      PrintResult._(success: true, jobId: jobId);

  factory PrintResult.failure(String message) =>
      PrintResult._(success: false, errorMessage: message);

  @override
  String toString() => success
      ? 'PrintResult(success, jobId: $jobId)'
      : 'PrintResult(failure: $errorMessage)';
}