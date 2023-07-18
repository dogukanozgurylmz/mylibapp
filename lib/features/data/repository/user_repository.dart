import '../../core/result/data_result.dart';
import '../../core/result/result.dart';
import '../model/user_model.dart';

abstract class UserRepository {
  Future<Result> createUser(UserModel model);
  Future<Result> update(UserModel model);
  Future<Result> delete(String id);
  Future<DataResult<UserModel>> getUserById(String id);
  Future<DataResult<UserModel>> getUserByEmail(String email);
}
