class ValidationResult {
  final bool isValid;
  final List<String> errorLog;

  const ValidationResult({required this.isValid, required this.errorLog});
}
