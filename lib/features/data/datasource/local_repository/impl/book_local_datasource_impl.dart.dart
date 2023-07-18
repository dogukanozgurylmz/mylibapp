import 'package:hive/hive.dart';
import 'package:mylib_app/features/core/result/data_result.dart';
import 'package:mylib_app/features/data/model/book_model.dart';

import '../../../../core/result/result.dart';
import '../book_local_datasource.dart';

class BookLocalDatasourceImpl extends BookLocalDatasource {
  @override
  Future<Result> create(List<BookModel> books) async {
    try {
      var box = await Hive.openBox<BookModel>('books');
      box.addAll(books);
      return Result.success("success");
    } catch (e) {
      return Result.fail("Fail message: $e");
    }
  }

  @override
  Future<Result> clear() async {
    try {
      var box = await Hive.openBox<BookModel>('books');
      box.clear();
      return Result.success("success");
    } catch (e) {
      return Result.fail("Fail message: $e");
    }
  }

  @override
  Future<DataResult<List<BookModel>>> getBooks() async {
    try {
      var box = await Hive.openBox<BookModel>('books');
      return DataResult.success("success", data: box.values.toList());
    } catch (e) {
      return DataResult.fail("Fail message $e");
    }
  }
}
