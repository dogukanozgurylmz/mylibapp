// ignore_for_file: constant_identifier_names

part of 'add_bookcase_cubit.dart';

enum AddBookcaseStatus {
  INIT,
  SUCCESS,
  ERROR,
  LOAD,
  LOADING,
}

class AddBookcaseState extends Equatable {
  final AddBookcaseStatus status;
  final bool isSubmit;

  const AddBookcaseState({
    required this.status,
    required this.isSubmit,
  });
  AddBookcaseState copyWith({
    AddBookcaseStatus? status,
    bool? isSubmit,
  }) {
    return AddBookcaseState(
      status: status ?? this.status,
      isSubmit: isSubmit ?? this.isSubmit,
    );
  }

  @override
  List<Object> get props => [
        status,
        isSubmit,
      ];
}
