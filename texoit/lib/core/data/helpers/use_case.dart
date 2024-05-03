import 'package:client/result.dart';
import 'package:equatable/equatable.dart';

import 'failures.dart';

abstract class UseCase<Type extends Object, Params> {
  Future<Result<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
