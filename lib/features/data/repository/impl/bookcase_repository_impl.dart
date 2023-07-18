import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mylib_app/features/data/model/bookcase_model.dart';
import 'package:mylib_app/features/data/repository/bookcase_repository.dart';
import 'package:mylib_app/features/data/repository/firebase_mixin.dart';

import '../../../core/result/data_result.dart';
import '../../../core/result/result.dart';

class BookcaseRepositoryImpl extends BookcaseRepository with FirebaseMixin {
  late final CollectionReference<Map<String, dynamic>> _ref;

  BookcaseRepositoryImpl() {
    _ref = firestore.collection('bookcases');
  }

  @override
  Future<Result> createBookcase(BookcaseModel model) async {
    try {
      String id = _ref.doc().id;
      model.id = id;
      await _ref.doc(id).set(model.toJson());
      return Result.success("success");
    } catch (e) {
      return Result.fail("Fail message: $e");
    }
  }

  @override
  Future<DataResult<List<BookcaseModel>>> getBookcasesByUserId(
      String userId) async {
    try {
      final List<BookcaseModel> list = [];
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _ref
          .where('user_id', isEqualTo: userId)
          .orderBy('created_at', descending: true)
          .get();
      querySnapshot.docs.map((doc) {
        list.add(BookcaseModel.fromJson(doc.data()));
      }).toList();
      return DataResult.success("success", data: list);
    } catch (e) {
      return DataResult.fail("Fail message: $e");
    }
  }

  @override
  Future<DataResult<BookcaseModel>> getBookcase(String id) async {
    try {
      var documentSnapshot = await _ref.doc(id).get();
      Map<String, dynamic>? data = documentSnapshot.data();
      return DataResult.success("success", data: BookcaseModel.fromJson(data!));
    } catch (e) {
      return DataResult.fail("Fail message: $e");
    }
  }

  @override
  Future<Result> update(BookcaseModel model) async {
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
      return Result.fail("Fail message: $e");
    }
  }
}
