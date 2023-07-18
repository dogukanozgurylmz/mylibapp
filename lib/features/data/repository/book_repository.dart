import '../../core/result/data_result.dart';
import '../../core/result/result.dart';
import '../model/book_model.dart';

abstract class BookRepository {
  Future<DataResult> createBook(BookModel model);
  Future<DataResult<List<BookModel>>> getBooks();
  Future<DataResult<List<BookModel>>> getBooksByIds(List<String> ids);
  Future<DataResult<BookModel>> getBookById(String id);
  Future<Result> updateBook(BookModel model);
  Future<Result> deleteBook(String id);
}
