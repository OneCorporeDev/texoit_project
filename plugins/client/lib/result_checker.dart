import 'package:client/result.dart';

class ResultChecker<ERR extends Object, OK extends Object> {
  ResultChecker(this._result);

  final Result<ERR, OK> _result;
  bool _hasMatched = false;

  void ifErr<ERR_T extends ERR>(void Function(ERR_T) callback) {
    if (!_hasMatched && _result.isErr && _result.err is ERR_T) {
      callback(_result.err as ERR_T);
      _hasMatched = true;
    }
  }

  void ifOk<OK_T extends OK>(void Function(OK_T) callback) {
    if (!_hasMatched && _result.isOk && _result.ok is OK_T) {
      callback(_result.ok as OK_T);
      _hasMatched = true;
    }
  }

  void elseDo(void Function() callback) {
    if (!_hasMatched) {
      callback();
    }
  }
}
