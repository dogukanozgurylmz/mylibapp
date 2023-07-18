import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mylib_app/features/data/datasource/local_repository/impl/user_local_datasource_impl.dart';
import 'package:mylib_app/features/data/model/bookcase_model.dart';
import 'package:mylib_app/features/data/repository/impl/bookcase_repository_impl.dart';

part 'add_bookcase_state.dart';

class AddBookcaseCubit extends Cubit<AddBookcaseState> {
  AddBookcaseCubit({
    required UserLocalDatasourceImpl userLocalDatasourceImpl,
    required BookcaseRepositoryImpl bookcaseRepositoryImpl,
  })  : _userLocalDatasourceImpl = userLocalDatasourceImpl,
        _bookcaseRepositoryImpl = bookcaseRepositoryImpl,
        super(const AddBookcaseState(
          status: AddBookcaseStatus.INIT,
          isSubmit: false,
        ));

  final UserLocalDatasourceImpl _userLocalDatasourceImpl;
  final BookcaseRepositoryImpl _bookcaseRepositoryImpl;

  final TextEditingController titleController = TextEditingController();

  Future<void> submitForm() async {
    emit(state.copyWith(isSubmit: true));
    await createBookcase();
    emit(state.copyWith(isSubmit: false));
    clearForm();
  }

  Future<void> createBookcase() async {
    var userModel = await _userLocalDatasourceImpl.currentUser();
    BookcaseModel bookcaseModel = BookcaseModel(
      id: '',
      title: titleController.text.trim(),
      bookIds: [],
      userId: userModel.data!.id,
      createdAt: DateTime.now(),
    );
    await _bookcaseRepositoryImpl.createBookcase(bookcaseModel);
  }

  void clearForm() {
    titleController.clear();
  }
}
