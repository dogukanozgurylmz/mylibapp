import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mylib_app/features/core/result/data_result.dart';
import 'package:mylib_app/features/data/datasource/local_repository/impl/book_local_datasource_impl.dart.dart';
import 'package:mylib_app/features/data/datasource/local_repository/impl/user_local_datasource_impl.dart';
import 'package:mylib_app/features/data/model/book_model.dart';

import '../../../data/model/user_model.dart';
import '../../../data/repository/impl/auth_repository_impl.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required UserLocalDatasourceImpl userLocalDatasourceImpl,
    required AuthRepositoryImpl authRepositoryImpl,
    required BookLocalDatasourceImpl bookLocalDatasourceImpl,
  })  : _userLocalDatasourceImpl = userLocalDatasourceImpl,
        _authRepositoryImpl = authRepositoryImpl,
        _bookLocalDatasourceImpl = bookLocalDatasourceImpl,
        super(ProfileState(
          status: ProfileStatus.INIT,
          userModel: UserModel(
            id: '',
            fullName: '',
            photoUrl: '',
            email: '',
            createdAt: DateTime.now(),
          ),
          books: const [],
          totalPages: "",
          totalWords: "",
        )) {
    init();
  }

  final UserLocalDatasourceImpl _userLocalDatasourceImpl;
  final AuthRepositoryImpl _authRepositoryImpl;
  final BookLocalDatasourceImpl _bookLocalDatasourceImpl;

  Future<void> init() async {
    emit(state.copyWith(status: ProfileStatus.LOADING));
    await currentUser();
    await getBooks();
    totalPages();
    totalWords();
    emit(state.copyWith(status: ProfileStatus.LOADED));
  }

  Future<void> currentUser() async {
    DataResult<UserModel> userModel =
        await _userLocalDatasourceImpl.currentUser();
    emit(state.copyWith(userModel: userModel.data));
  }

  Future<void> signOut() async {
    await _authRepositoryImpl.signOut();
  }

  Future<void> getBooks() async {
    DataResult<List<BookModel>> list =
        await _bookLocalDatasourceImpl.getBooks();
    emit(state.copyWith(books: list.data));
  }

  void totalPages() {
    int total = 0;
    for (var e in state.books) {
      total = total + e.page;
    }
    emit(state.copyWith(totalPages: total.toString()));
  }

  void totalWords() {
    int total = 0;
    for (var e in state.books) {
      total = total + (e.page * 250);
    }
    emit(state.copyWith(totalWords: total.toString()));
  }
}
