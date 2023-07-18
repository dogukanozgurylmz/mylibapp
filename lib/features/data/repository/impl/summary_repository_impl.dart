import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mylib_app/features/data/model/summary_model.dart';
import 'package:mylib_app/features/data/repository/firebase_mixin.dart';
import 'package:mylib_app/features/data/repository/summary_repository.dart';

import '../../../core/result/data_result.dart';
import '../../../core/result/result.dart';

class SummaryRepositoryImpl extends SummaryRepository with FirebaseMixin {
  late final CollectionReference<Map<String, dynamic>> _ref;

  SummaryRepositoryImpl() {
    _ref = firestore.collection('summaries');
  }

  @override
  Future<Result> create(SummaryModel model) async {
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
  Future<DataResult<SummaryModel>> getById(String id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await _ref.doc(id).get();
      return DataResult.success("success",
          data: SummaryModel.fromJson(docSnapshot.data()!));
    } catch (e) {
      return DataResult.fail("Fail message: $e");
    }
  }

  @override
  Future<DataResult<SummaryModel>> getByBookId(String bookId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _ref.where('book_id', isEqualTo: bookId).get();
      return DataResult.success("success",
          data: SummaryModel.fromJson(querySnapshot.docs.first.data()));
    } catch (e) {
      return DataResult.fail("Fail message: $e");
    }
  }

  @override
  Future<DataResult<List<SummaryModel>>> getAllByBookIds(
      List<String> bookIds) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _ref.where('book_id', whereIn: bookIds).get();

      List<SummaryModel> list = querySnapshot.docs
          .map((e) => SummaryModel.fromJson(e.data()))
          .toList();
      return DataResult.success("success", data: list);
    } catch (e) {
      return DataResult.fail("Fail message: $e");
    }
  }

  @override
  Future<Result> update(SummaryModel model) async {
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
