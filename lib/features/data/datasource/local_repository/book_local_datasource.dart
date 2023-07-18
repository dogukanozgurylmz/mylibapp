import 'package:mylib_app/features/data/model/book_model.dart';

import '../../../core/result/data_result.dart';
import '../../../core/result/result.dart';

abstract class BookLocalDatasource {
  Future<Result> create(List<BookModel> books);
  Future<Result> clear();
  Future<DataResult<List<BookModel>>> getBooks();
}
