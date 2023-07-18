import '../../../core/result/data_result.dart';
import '../../../core/result/result.dart';
import '../../model/user_model.dart';

abstract class UserLocalDatasource {
  Future<Result> create(UserModel model);
  Future<Result> clear();
  Future<DataResult<UserModel>> currentUser();
}
