class DialogResult {
  final DialogResultCode code;

  DialogResult({
    required this.code,
  });
}

enum DialogResultCode {
  ok,
  error,
}
