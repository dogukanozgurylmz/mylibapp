import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mylib_app/features/core/result/data_result.dart';
import 'package:mylib_app/features/data/datasource/local_repository/impl/book_local_datasource_impl.dart.dart';

import '../../../data/model/book_model.dart';

part 'bookcase_details_state.dart';

class BookcaseDetailsCubit extends Cubit<BookcaseDetailsState> {
  BookcaseDetailsCubit({
    required BookLocalDatasourceImpl bookLocalDatasourceImpl,
  })  : _bookLocalDatasourceImpl = bookLocalDatasourceImpl,
        super(const BookcaseDetailsState(
          status: BookcaseDetailsStatus.INIT,
          books: [],
        ));

  final BookLocalDatasourceImpl _bookLocalDatasourceImpl;

  Future<void> getBooks(List<String> bookIds) async {
    List<BookModel> books = [];
    DataResult<List<BookModel>> list =
        await _bookLocalDatasourceImpl.getBooks();
    if (!list.success) {
      return;
    }
    for (var id in bookIds) {
      print(list.message);
      var firstWhere = list.data!.firstWhere((element) => element.id == id);
      books.add(firstWhere);
    }
    emit(state.copyWith(books: books));
  }
}
