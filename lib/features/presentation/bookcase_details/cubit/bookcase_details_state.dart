// ignore_for_file: constant_identifier_names

part of 'bookcase_details_cubit.dart';

enum BookcaseDetailsStatus {
  INIT,
  LOAD,
  LOADING,
}

class BookcaseDetailsState extends Equatable {
  final BookcaseDetailsStatus status;
  final List<BookModel> books;

  const BookcaseDetailsState({
    required this.status,
    required this.books,
  });

  BookcaseDetailsState copyWith({
    BookcaseDetailsStatus? status,
    List<BookModel>? books,
  }) {
    return BookcaseDetailsState(
      status: status ?? this.status,
      books: books ?? this.books,
    );
  }

  @override
  List<Object> get props => [
        status,
        books,
      ];
}
