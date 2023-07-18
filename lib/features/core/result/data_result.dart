import 'result.dart';

class DataResult<T> extends Result {
  T? data;

  DataResult(bool success, String message, {required this.data})
      : super(success, message);

  DataResult.success(String message, {required this.data})
      : super(true, message);

  DataResult.fail(String message) : super(false, message);
}
