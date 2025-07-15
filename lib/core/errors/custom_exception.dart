class CustomException implements Exception {
  final String errMessage;
  const CustomException(this.errMessage);
  @override
  String toString() => 'CustomException: $errMessage';
}
