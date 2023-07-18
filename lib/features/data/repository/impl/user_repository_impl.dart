import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mylib_app/features/data/repository/firebase_mixin.dart';
import 'package:mylib_app/features/data/repository/user_repository.dart';

import '../../../core/result/data_result.dart';
import '../../../core/result/result.dart';
import '../../model/user_model.dart';

class UserRepositoryImpl extends UserRepository with FirebaseMixin {
  late final CollectionReference<Map<String, dynamic>> _ref;

  UserRepositoryImpl() {
    _ref = firestore.collection('users');
  }

  @override
  Future<Result> createUser(UserModel model) async {
    try {
      String id = _ref.doc().id;
      model.id = id;
      await _ref.doc(id).set(model.toJson());
      return Result.success("Success");
    } catch (e) {
      return Result.fail("Fail message: $e");
    }
  }

  @override
  Future<DataResult<UserModel>> getUserById(String id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await _ref.doc(id).get();
      return DataResult.success("Success",
          data: UserModel.fromJson(docSnapshot.data()!));
    } catch (e) {
      return DataResult.fail("Fail message $e");
    }
  }

  @override
  Future<DataResult<UserModel>> getUserByEmail(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _ref.where('email', isEqualTo: email).get();
      return DataResult.success("success",
          data: UserModel.fromJson(querySnapshot.docs.first.data()));
    } catch (e) {
      return DataResult.fail("Fail message: $e");
    }
  }

  @override
  Future<Result> update(UserModel model) async {
    try {
      await _ref.doc(model.id).update(model.toJson());
      return Result.success("success");
    } catch (e) {
      return Result.fail("Fail message: $e");
    }
  }

  @override
  Future<Result> delete(String id) async {
    try {
      await _ref.doc(id).delete();
      return Result.success("success");
    } catch (e) {
      return Result.fail("Fail message $e");
    }
  }
}
