library client;

import 'package:client/result_checker.dart';
import 'package:flutter_test/flutter_test.dart';

abstract class Result<ERR extends Object, OK extends Object> {
  const Result();

  bool get isErr => this is Err<ERR, OK>;

  bool get isOk => this is Ok<ERR, OK>;

  ERR get err {
    if (!isErr) {
      throw ResultException('Did not check isErr before getting err');
    }

    return (this as Err<ERR, OK>).val;
  }

  OK get ok {
    if (!isOk) {
      throw ResultException('Did not check isOk before getting ok');
    }

    return (this as Ok<ERR, OK>).val;
  }

  ResultChecker<ERR, OK> get check => ResultChecker(this);

  Result<ERR_OUT, OK_OUT> map<ERR_OUT extends Object, OK_OUT extends Object>({
    required Result<ERR_OUT, OK_OUT> Function(ERR) onErr,
    required Result<ERR_OUT, OK_OUT> Function(OK) onOk,
  }) =>
      isOk ? onOk(ok) : onErr(err);

  Future<Result<ERR_OUT, OK_OUT>> mapFuture<ERR_OUT extends Object, OK_OUT extends Object>({
    required Future<Result<ERR_OUT, OK_OUT>> Function(ERR) onErr,
    required Future<Result<ERR_OUT, OK_OUT>> Function(OK) onOk,
  }) async =>
      isOk ? await onOk(ok) : await onErr(err);

  @override
  String toString();
}

class ResultException implements Exception {
  ResultException(this.message);
  final String message;
}

class Err<ERR extends Object, OK extends Object> extends Result<ERR, OK> {
  const Err(this.val);
  final ERR val;

  @override
  String toString() => 'Err($val)';
}

class Ok<ERR extends Object, OK extends Object> extends Result<ERR, OK> {
  const Ok(this.val);
  final OK val;

  @override
  String toString() => 'Ok($val)';
}

extension ErrListExtension<T> on List<T> {
  bool containsType(Type type) => any((element) => element.runtimeType == type);
}

class IsAOkResult<T> extends Matcher {
  @override
  Description describe(Description description) => description.add('is a Ok Result');

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is Result && item.isOk) {
      return item.ok is T;
    }

    return false;
  }
}

IsAOkResult isAOkResult<T>() => IsAOkResult<T>();

class IsAErrResult<T> extends Matcher {
  @override
  Description describe(Description description) => description.add('is a Err Result');

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is Result && item.isErr) {
      return item.err is T;
    }

    return false;
  }
}

IsAErrResult isAErrResult<T>() => IsAErrResult<T>();
