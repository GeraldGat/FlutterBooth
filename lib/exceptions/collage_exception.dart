class CollageException implements Exception {
  final String message;
  final String? details;

  const CollageException(
    this.message, {
    this.details,
});

  @override
  String toString() {
    return 'CollageException(message: $message, details: $details)';
  }
}