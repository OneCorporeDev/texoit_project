import 'dart:convert';

import 'package:serialization/serializable.dart';

class Json implements Serializable<Json> {
  Json(this._json);
  factory Json.empty() => Json({});
  factory Json.decode(String json) => Json(jsonDecode(json));

  Map<String, dynamic> _json;

  @override
  Json fromJson(Json json) => this;

  @override
  Map<String, dynamic> toJson() => _json;

  dynamic _readField(String key) {
    final splitKey = key.split('.').map((k) => k.trim()).toList();
    dynamic value = _json;

    for (final k in splitKey) {
      if (value is Map) {
        value = value[k];
      } else {
        return null;
      }
    }

    return value;
  }

  bool get isEmpty => _json.isEmpty;
  bool get isNotEmpty => _json.isNotEmpty;
  Map<String, dynamic> get raw => _json;

  /// Lê um objeto JSON do objeto JSON especificado pela sua chave.
  /// Se a chave não for encontrada, um objeto JSON vazio é retornado.
  /// Se a chave for encontrada, mas não for um objeto JSON, um objeto JSON vazio é retornado.
  /// Este método retorna um tipo não nulo.
  Json readJson(String key) {
    final value = _readField(key);

    if (value is! Map<String, dynamic>) {
      return Json.empty();
    }

    return Json(value);
  }

  /// Lê um objeto personalizado do objeto JSON especificado pela sua chave.
  /// Se a chave não for encontrada, é retornado null.
  /// Se o valor não for um objeto JSON, é retornado null.
  /// O valor é mapeado para o objeto personalizado pela função de retorno de chamada `fromJson`.
  T? readCustomObject<T>(String key, T Function(Json) fromJson) {
    if (!hasField(key)) {
      return null;
    }
    final value = readJson(key);
    return fromJson(value);
  }

  /// Lê uma lista de objetos JSON do objeto JSON especificado pela sua chave.
  /// Se a chave não for encontrada, é retornado null.
  /// Se a chave for encontrada, mas não for uma lista de objetos JSON, é retornado null.
  List<Json>? readJsonList(String key) {
    final value = _readField(key);

    if (value is! List<dynamic>) {
      return null;
    }

    for (final v in value) {
      if (v is! Map<String, dynamic>) {
        return null;
      }
    }

    return value.map((v) => Json(v as Map<String, dynamic>)).toList();
  }

  bool hasField(String key) => _readField(key) != null;

  List<T>? _readList<T>(dynamic value, Function(dynamic) mapper) {
    if (value is! List) {
      return null;
    }

    final list = <T>[];

    for (final item in value) {
      final val = mapper(item) as T?;

      if (val == null) {
        return null;
      }

      list.add(val);
    }

    return list;
  }

  String? readString(dynamic value) => _readField(value);

  List<String>? readStringList(String key) {
    final value = _readField(key);

    if (value is! List<dynamic>) {
      return null;
    }

    for (final v in value) {
      if (v is! String) {
        return null;
      }
    }

    return <String>[...value];
  }

  int? readInt(dynamic value) {
    final field = _readField(value);
    if (field == null) {
      return null;
    }

    return num.tryParse(field.toString())?.toInt();
  }

  List<int>? readIntList(String key) {
    final value = _readField(key);

    if (value is! List<dynamic>) {
      return null;
    }

    for (final v in value) {
      if (v is! int) {
        return null;
      }
    }

    return _readList(value, (val) => num.tryParse(val.toString())?.toInt());
  }

  double? readDouble(dynamic value) {
    final field = _readField(value);
    if (field == null) {
      return null;
    }
    return num.tryParse(field.toString())?.toDouble();
  }

  List<double>? readDoubleList(dynamic value) => _readList(value, readDouble);

  num? readNum(dynamic value) {
    if (value == null) {
      return null;
    }

    return num.tryParse(value.toString());
  }

  List<num>? readNumList(dynamic value) => _readList(value, readNum);

  bool? readBool(dynamic value) {
    final field = _readField(value);
    if (field == null) {
      return null;
    }

    if (field.toString() == 'true' || field.toString() == '1') {
      return true;
    }

    if (field.toString() == 'false' || field.toString() == '0') {
      return false;
    }

    return null;
  }

  List<bool>? readBoolList(dynamic value) => _readList(value, readBool);

  DateTime? readDateTime(String key) {
    final dynamic value = _readField(key);

    if (value == null) {
      return null;
    }

    final valueWithoutMicroseconds = value.toString().replaceAllMapped(
          RegExp(r'(\.\d{3})\d{3}'),
          (match) => match.group(1) ?? '',
        );

    return DateTime.tryParse(valueWithoutMicroseconds)?.toLocal();
  }
}
