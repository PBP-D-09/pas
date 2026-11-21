/// Pembaca JSON yang ketat: tipe yang tidak sesuai kontrak API langsung
/// dilaporkan sebagai [FormatException] beserta nama field-nya.
class JsonReader {
  JsonReader(Object? value, [this.path = 'response'])
    : json = _asMap(value, path);

  final Map<String, Object?> json;
  final String path;

  String _field(String key) => '$path.$key';

  String string(String key) {
    final value = json[key];
    if (value is String) return value;
    throw FormatException('Expected a string for ${_field(key)}.');
  }

  String? nullableString(String key) {
    return json[key] == null ? null : string(key);
  }

  int integer(String key) {
    final value = json[key];
    if (value is int) return value;
    throw FormatException('Expected an integer for ${_field(key)}.');
  }

  int? nullableInteger(String key) {
    return json[key] == null ? null : integer(key);
  }

  bool boolean(String key) {
    final value = json[key];
    if (value is bool) return value;
    throw FormatException('Expected a boolean for ${_field(key)}.');
  }

  DateTime? dateTime(String key) {
    final value = nullableString(key);
    return value == null ? null : DateTime.tryParse(value)?.toLocal();
  }

  JsonReader object(String key) => JsonReader(json[key], _field(key));

  List<T> list<T>(String key, T Function(JsonReader item) parse) {
    final value = json[key];
    if (value is! List) {
      throw FormatException('Expected a list for ${_field(key)}.');
    }
    return [
      for (var i = 0; i < value.length; i++)
        parse(JsonReader(value[i], '${_field(key)}[$i]')),
    ];
  }

  Map<String, int> intMap(String key) {
    final reader = object(key);
    return {for (final entry in reader.json.keys) entry: reader.integer(entry)};
  }

  static Map<String, Object?> _asMap(Object? value, String path) {
    if (value is Map) {
      return value.map((key, value) => MapEntry(key.toString(), value));
    }
    throw FormatException('Expected an object for $path.');
  }
}
