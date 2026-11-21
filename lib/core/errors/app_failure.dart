class AppFailure implements Exception {
  const AppFailure(this.message, {this.statusCode});

  final String message;

  /// Kode status HTTP jika kegagalan berasal dari respons server.
  final int? statusCode;

  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() => message;
}
