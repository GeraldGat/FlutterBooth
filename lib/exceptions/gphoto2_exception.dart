class GPhoto2Exception implements Exception {
  final String message;
  final List<String> options;

  const GPhoto2Exception(
    this.message,
    this.options,
  );

  @override
  String toString() {
    return 'GPhoto2Exception(message: $message, options: ${options.join(", ")})';
  }
}