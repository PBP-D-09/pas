abstract interface class ApiClient {
  Future<Object?> get(String path);

  Future<Object?> post(
    String path, {
    Map<String, Object?> body = const <String, Object?>{},
  });

  Future<Object?> patch(
    String path, {
    Map<String, Object?> body = const <String, Object?>{},
  });

  Future<Object?> delete(String path);
}
