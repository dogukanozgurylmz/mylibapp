import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mylib_app/features/core/result/data_result.dart';
import 'package:mylib_app/features/data/datasource/local_repository/impl/user_local_datasource_impl.dart';
import 'package:mylib_app/features/data/model/book_model.dart';
import 'package:mylib_app/features/data/model/bookcase_model.dart';
import 'package:mylib_app/features/data/repository/impl/auth_repository_impl.dart';

import '../../../data/model/user_model.dart';
import '../../../data/repository/impl/book_repository_impl.dart';
import '../../../data/repository/impl/bookcase_repository_impl.dart';

part 'add_book_state.dart';

class AddBookCubit extends Cubit<AddBookState> {
  AddBookCubit({
    required BookRepositoryImpl bookRepositoryImpl,
    required BookcaseRepositoryImpl bookcaseRepositoryImpl,
    required UserLocalDatasourceImpl userLocalDatasourceImpl,
  })  : _bookRepositoryImpl = bookRepositoryImpl,
        _bookcaseRepositoryImpl = bookcaseRepositoryImpl,
        _userLocalDatasourceImpl = userLocalDatasourceImpl,
        super(AddBookState(
          status: AddBookStatus.INIT,
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          bookcases: const [],
          selectedBookcase: "",
          isSubmit: false,
          isReading: false,
        )) {
    init();
  }

  final BookRepositoryImpl _bookRepositoryImpl;
  final BookcaseRepositoryImpl _bookcaseRepositoryImpl;
  final UserLocalDatasourceImpl _userLocalDatasourceImpl;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController pageCountController = TextEditingController();

  String _bookId = "";

  Future<void> init() async {
    emit(state.copyWith(status: AddBookStatus.LOADING));
    await getBookcasesByUserId();
    emit(state.copyWith(status: AddBookStatus.LOADED));
  }

  void onTapStartDate(DateTime selectedDate) {
    if (selectedDate != null) {
      emit(state.copyWith(startDate: selectedDate));
    } else {
      emit(state.copyWith(startDate: DateTime.now()));
    }
  }

  void onTapEndDate(DateTime selectedDate) {
    if (selectedDate != null) {
      emit(state.copyWith(endDate: selectedDate));
    } else {
      emit(state.copyWith(endDate: DateTime.now()));
    }
  }

  void selectBookcase(String value) {
    emit(state.copyWith(selectedBookcase: value));
  }

  void changeReading(bool value) {
    emit(state.copyWith(isReading: value));
  }

  Future<void> getBookcasesByUserId() async {
    DataResult<UserModel> userModel =
        await _userLocalDatasourceImpl.currentUser();
    DataResult<List<BookcaseModel>> bookcases =
        await _bookcaseRepositoryImpl.getBookcasesByUserId(userModel.data!.id);
    emit(state.copyWith(bookcases: bookcases.data));
  }

  Future<void> submitForm() async {
    emit(state.copyWith(isSubmit: true));
    await createBook();
    await updateBookcase(_bookId);
    clearForm();
    emit(state.copyWith(isSubmit: false));
  }

  Future<void> createBook() async {
    var currentUser = await _userLocalDatasourceImpl.currentUser();
    BookModel bookModel = BookModel(
      id: '',
      bookName: titleController.text.trim(),
      author: authorController.text.trim(),
      page: int.parse(pageCountController.text),
      isReading: state.isReading,
      starterDate: state.startDate,
      endDate: state.endDate,
      createdAt: DateTime.now(),
      userId: currentUser.data!.id,
    );
    var dataResult = await _bookRepositoryImpl.createBook(bookModel);
    _bookId = dataResult.data;
  }

  Future<void> updateBookcase(String bookId) async {
    BookcaseModel firstWhere = state.bookcases
        .firstWhere((element) => element.title == state.selectedBookcase);
    firstWhere.bookIds.add(bookId);
    await _bookcaseRepositoryImpl.update(firstWhere);
  }

  void clearForm() {
    titleController.clear();
    pageCountController.clear();
    authorController.clear();
    emit(state.copyWith(
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    ));
  }
}
