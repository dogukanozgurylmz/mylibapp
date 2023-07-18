class Result {
  bool success;
  String message;

  Result(this.success, this.message);

  Result.success(this.message) : success = true;

  Result.fail(this.message) : success = false;
}
