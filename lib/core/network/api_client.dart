abstract interface class ApiClient {
  Future<Object?> get(String path);

  Future<Object?> post(
    String path, {
    Map<String, Object?> body = const <String, Object?>{},
  });
}
