// ignore_for_file: constant_identifier_names

part of 'add_book_cubit.dart';

enum AddBookStatus {
  INIT,
  LOADING,
  LOADED,
}

class AddBookState extends Equatable {
  final AddBookStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final List<BookcaseModel> bookcases;
  final String selectedBookcase;
  final bool isSubmit;
  final bool isReading;

  const AddBookState({
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.bookcases,
    required this.selectedBookcase,
    required this.isSubmit,
    required this.isReading,
  });

  AddBookState copyWith({
    AddBookStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    List<BookcaseModel>? bookcases,
    String? selectedBookcase,
    bool? isSubmit,
    bool? isReading,
  }) {
    return AddBookState(
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      bookcases: bookcases ?? this.bookcases,
      selectedBookcase: selectedBookcase ?? this.selectedBookcase,
      isSubmit: isSubmit ?? this.isSubmit,
      isReading: isReading ?? this.isReading,
    );
  }

  @override
  List<Object?> get props => [
        status,
        startDate,
        endDate,
        bookcases,
        selectedBookcase,
        isSubmit,
        isReading,
      ];
}
