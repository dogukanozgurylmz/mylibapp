import '../../core/result/data_result.dart';
import '../../core/result/result.dart';
import '../model/summary_model.dart';

abstract class SummaryRepository {
  Future<Result> create(SummaryModel model);
  Future<DataResult<SummaryModel>> getById(String id);
  Future<DataResult<SummaryModel>> getByBookId(String bookId);
  Future<DataResult<List<SummaryModel>>> getAllByBookIds(List<String> bookIds);
  Future<Result> update(SummaryModel model);
  Future<Result> delete(String id);
}
