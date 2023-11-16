
sealed class Result<D, I extends Enum?> {
  factory Result.success(D data) {
    return Success<D, I>._(data);
  }

  factory Result.fail(I issue,) {
    return Fail<D, I>._(issue);
  }

  bool get isSuccess;
  bool get isFail;
}

class Success<D, I extends Enum?> implements Result<D, I> {
  Success._(this.data);

  final D data;

  @override
  bool get isFail => false;

  @override
  bool get isSuccess => true;
}

class Fail<D, I extends Enum?> implements Result<D, I> {
  Fail._(this.issue);

  final I issue;

  @override
  bool get isFail => true;

  @override
  bool get isSuccess => false;
}

enum DefaultIssue {
  unknown,
  badRequest,
  unAuthorized,
}
