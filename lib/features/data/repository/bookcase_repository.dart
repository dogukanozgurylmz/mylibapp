import '../../core/result/data_result.dart';
import '../../core/result/result.dart';
import '../model/bookcase_model.dart';

abstract class BookcaseRepository {
  Future<Result> createBookcase(BookcaseModel model);
  Future<DataResult<List<BookcaseModel>>> getBookcasesByUserId(String userId);
  Future<DataResult<BookcaseModel>> getBookcase(String id);
  Future<Result> update(BookcaseModel model);
  Future<Result> delete(String id);
}
