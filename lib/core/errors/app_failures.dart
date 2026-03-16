abstract class AppFailure {
  final String message;
  final String? details;
  final StackTrace? stackTrace;

  const AppFailure({
    required this.message,
    this.details,
    this.stackTrace,
  });
}

class BootstrapFailure extends AppFailure {
  const BootstrapFailure({
    required super.message,
    super.details,
    super.stackTrace,
  });
}
