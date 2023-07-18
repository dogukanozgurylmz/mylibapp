import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mylib_app/features/data/model/book_model.dart';
import 'package:mylib_app/features/data/repository/book_repository.dart';
import 'package:mylib_app/features/data/repository/firebase_mixin.dart';

import '../../../core/result/data_result.dart';
import '../../../core/result/result.dart';

class BookRepositoryImpl extends BookRepository with FirebaseMixin {
  late final CollectionReference<Map<String, dynamic>> _ref;

  BookRepositoryImpl() {
    _ref = firestore.collection('books');
  }

  @override
  Future<DataResult> createBook(BookModel model) async {
    try {
      String id = _ref.doc().id;
      model.id = id;
      await _ref.doc(id).set(model.toJson());
      return DataResult.success("success", data: id);
    } catch (e) {
      return DataResult.fail("Fail message: $e");
    }
  }

  @override
  Future<Result> deleteBook(String id) async {
    try {
      await _ref.doc(id).delete();
      return Result.success("success");
    } catch (e) {
      return Result.fail("Fail message: $e");
    }
  }

  @override
  Future<DataResult<BookModel>> getBookById(String id) async {
    try {
      var documentSnapshot = await _ref.doc(id).get();
      Map<String, dynamic>? data = documentSnapshot.data();
      return DataResult.success("success", data: BookModel.fromJson(data!));
    } catch (e) {
      return DataResult.fail("Fail message: $e");
    }
  }

  @override
  Future<DataResult<List<BookModel>>> getBooks() async {
    try {
      final List<BookModel> list = [];
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _ref.orderBy('created_at', descending: true).get();
      querySnapshot.docs
          .map((e) => list.add(BookModel.fromJson(e.data())))
          .toList();
      return DataResult.success("Fetch all book", data: list);
    } catch (e) {
      return DataResult.fail("message: ${e.toString()}");
    }
  }

  @override
  Future<DataResult<List<BookModel>>> getBooksByIds(List<String> ids) async {
    try {
      final List<BookModel> list = [];
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _ref
          .where('id', whereIn: ids)
          .orderBy('created_at', descending: true)
          .get();
      list.addAll(querySnapshot.docs.map((e) => BookModel.fromJson(e.data())));
      return DataResult.success("Success", data: list);
    } catch (e) {
      return DataResult.fail("message: ${e.toString()}");
    }
  }

  @override
  Future<Result> updateBook(BookModel model) async {
    try {
      await _ref.doc(model.id).update(model.toJson());
      return Result.success("success");
    } catch (e) {
      return Result.fail("message: ${e.toString()}");
    }
  }
}
