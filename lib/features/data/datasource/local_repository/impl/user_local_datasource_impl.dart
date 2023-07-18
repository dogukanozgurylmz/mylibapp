import 'package:hive/hive.dart';
import '../../../../core/result/data_result.dart';
import '../../../../core/result/result.dart';
import '../../../model/user_model.dart';
import '../user_local_datasource.dart';

class UserLocalDatasourceImpl extends UserLocalDatasource {
  @override
  Future<Result> create(UserModel model) async {
    try {
      var box = await Hive.openBox<UserModel>('users');
      box.add(model);
      return Result.success("success");
    } catch (e) {
      return Result.fail("Fail message: $e");
    }
  }

  @override
  Future<Result> clear() async {
    try {
      var box = await Hive.openBox<UserModel>('users');
      box.clear();
      return Result.success("success");
    } catch (e) {
      return Result.fail("Fail message: $e");
    }
  }

  @override
  Future<DataResult<UserModel>> currentUser() async {
    try {
      var box = await Hive.openBox<UserModel>('users');
      return DataResult.success("success", data: box.values.first);
    } catch (e) {
      return DataResult.fail("Fail message: $e");
    }
  }
}
