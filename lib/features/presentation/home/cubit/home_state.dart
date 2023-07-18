// ignore_for_file: constant_identifier_names

part of 'home_cubit.dart';

enum HomeStatus {
  INIT,
  SUCCESS,
  ERROR,
  LOADED,
  LOADING,
}

class HomeState extends Equatable {
  final HomeStatus status;
  final UserModel userModel;
  final List<BookModel> books;
  final List<BookcaseModel> bookcases;
  final List<SummaryModel> summaries;
  final bool deleteLoading;

  const HomeState({
    required this.status,
    required this.userModel,
    required this.books,
    required this.bookcases,
    required this.summaries,
    required this.deleteLoading,
  });

  HomeState copyWith({
    HomeStatus? status,
    UserModel? userModel,
    List<BookModel>? books,
    List<BookcaseModel>? bookcases,
    List<SummaryModel>? summaries,
    bool? deleteLoading,
  }) {
    return HomeState(
      status: status ?? this.status,
      userModel: userModel ?? this.userModel,
      books: books ?? this.books,
      bookcases: bookcases ?? this.bookcases,
      summaries: summaries ?? this.summaries,
      deleteLoading: deleteLoading ?? this.deleteLoading,
    );
  }

  @override
  List<Object?> get props => [
        status,
        userModel,
        books,
        bookcases,
        summaries,
        deleteLoading,
      ];
}
