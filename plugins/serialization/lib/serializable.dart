import 'package:serialization/json.dart';

abstract class Serializable<T> {
  Map<String, dynamic> toJson();
  T fromJson(Json json);
}
