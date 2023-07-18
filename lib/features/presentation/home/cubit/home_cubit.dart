import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mylib_app/features/core/result/data_result.dart';
import 'package:mylib_app/features/data/datasource/local_repository/impl/book_local_datasource_impl.dart.dart';
import 'package:mylib_app/features/data/model/summary_model.dart';
import 'package:mylib_app/features/data/repository/impl/auth_repository_impl.dart';
import 'package:mylib_app/features/data/repository/impl/book_repository_impl.dart';
import 'package:mylib_app/features/data/repository/impl/bookcase_repository_impl.dart';
import 'package:mylib_app/features/data/repository/impl/summary_repository_impl.dart';
import 'package:mylib_app/features/data/repository/impl/user_repository_impl.dart';

import '../../../data/model/book_model.dart';
import '../../../data/model/bookcase_model.dart';
import '../../../data/model/user_model.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required AuthRepositoryImpl authRepositoryImpl,
    required BookRepositoryImpl bookRepositoryImpl,
    required BookcaseRepositoryImpl bookcaseRepositoryImpl,
    required UserRepositoryImpl userRepositoryImpl,
    required BookLocalDatasourceImpl bookLocalDatasourceImpl,
    required SummaryRepositoryImpl summaryRepositoryImpl,
  })  : _authRepositoryImpl = authRepositoryImpl,
        _bookRepositoryImpl = bookRepositoryImpl,
        _bookcaseRepositoryImpl = bookcaseRepositoryImpl,
        _userRepositoryImpl = userRepositoryImpl,
        _bookLocalDatasourceImpl = bookLocalDatasourceImpl,
        _summaryRepositoryImpl = summaryRepositoryImpl,
        super(HomeState(
          status: HomeStatus.INIT,
          userModel: UserModel(
            id: '',
            fullName: '',
            photoUrl: '',
            email: '',
            createdAt: DateTime.now(),
          ),
          books: const [],
          bookcases: const [],
          summaries: const [],
          deleteLoading: false,
        )) {
    init();
  }

  Future<void> init() async {
    emit(state.copyWith(status: HomeStatus.LOADING));
    await clearLocalBooks();
    await currentUser();
    await getBookcasesByUserId();
    await getBooksByIds();
    await createLocalBooks(state.books);
    getDateData();
    emit(state.copyWith(status: HomeStatus.LOADED));
  }

  final AuthRepositoryImpl _authRepositoryImpl;
  final BookRepositoryImpl _bookRepositoryImpl;
  final BookcaseRepositoryImpl _bookcaseRepositoryImpl;
  final UserRepositoryImpl _userRepositoryImpl;
  final BookLocalDatasourceImpl _bookLocalDatasourceImpl;
  final SummaryRepositoryImpl _summaryRepositoryImpl;

  Future<void> currentUser() async {
    var currentUser = _authRepositoryImpl.currentUser;
    DataResult<UserModel> dataResult =
        await _userRepositoryImpl.getUserByEmail(currentUser!.email ?? "");
    if (!dataResult.success) {
      print("home cubit hata");
      return;
    }

    emit(state.copyWith(
        userModel: UserModel(
      id: dataResult.data!.id,
      fullName: dataResult.data!.fullName,
      photoUrl: dataResult.data!.photoUrl,
      email: dataResult.data!.email,
      createdAt: dataResult.data!.createdAt,
    )));
  }

  Future<void> getBookcasesByUserId() async {
    DataResult<List<BookcaseModel>> dataResult =
        await _bookcaseRepositoryImpl.getBookcasesByUserId(state.userModel.id);
    emit(state.copyWith(bookcases: dataResult.data));
  }

  Future<void> getBooksByIds() async {
    List<String> bookIds = [];
    for (var e in state.bookcases) {
      bookIds.addAll(e.bookIds);
    }
    await getAllSummaries(bookIds);
    DataResult<List<BookModel>> dataResult =
        await _bookRepositoryImpl.getBooksByIds(bookIds);
    if (!dataResult.success) {
      print("getBooksByIds error");
      return;
    }
    dataResult.data!.sort(
      (a, b) => b.starterDate.compareTo(a.starterDate),
    );
    emit(state.copyWith(books: dataResult.data));
  }

  Future<void> getAllSummaries(List<String> bookIds) async {
    DataResult<List<SummaryModel>> dataResult =
        await _summaryRepositoryImpl.getAllByBookIds(bookIds);
    emit(state.copyWith(summaries: dataResult.data));
  }

  Future<void> deleteBookcase(BookcaseModel model) async {
    await _bookcaseRepositoryImpl.delete(model.id);
    state.bookcases.remove(model);
    await updateBookcase(model);
    emit(state.copyWith(bookcases: state.bookcases));
  }

  Future<void> updateBookcase(BookcaseModel model) async {
    state.bookcases.first.bookIds.addAll(model.bookIds);
    await _bookcaseRepositoryImpl.update(state.bookcases.first);
  }

  Future<void> createLocalBooks(List<BookModel> books) async {
    await _bookLocalDatasourceImpl.create(books);
  }

  Future<void> clearLocalBooks() async {
    await _bookLocalDatasourceImpl.clear();
  }

  List<ChartData> getDateData() {
    Map<String, int> bookCounts = {};
    var where =
        state.books.where((element) => element.isReading == true).toList();
    for (BookModel book in where) {
      int year = book.endDate.year;
      int month = book.endDate.month;

      String key = '$year-$month';
      bookCounts[key] = (bookCounts[key] ?? 0) + 1;
    }

    List<ChartData> data = [];
    bookCounts.forEach((key, value) {
      List<String> parts = key.split('-');
      int year = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      data.add(ChartData(DateTime(year, month), value.toDouble()));
    });

    return data;
  }
}

class ChartData {
  DateTime category;
  double value;

  ChartData(this.category, this.value);
}
