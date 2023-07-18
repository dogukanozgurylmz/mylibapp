// ignore_for_file: constant_identifier_names

part of 'profile_cubit.dart';

enum ProfileStatus {
  INIT,
  SUCCESS,
  ERROR,
  LOADED,
  LOADING,
}

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserModel userModel;
  final List<BookModel> books;
  final String totalPages;
  final String totalWords;

  const ProfileState({
    required this.status,
    required this.userModel,
    required this.books,
    required this.totalPages,
    required this.totalWords,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserModel? userModel,
    List<BookModel>? books,
    String? totalPages,
    String? totalWords,
  }) {
    return ProfileState(
      status: status ?? this.status,
      userModel: userModel ?? this.userModel,
      books: books ?? this.books,
      totalPages: totalPages ?? this.totalPages,
      totalWords: totalWords ?? this.totalWords,
    );
  }

  @override
  List<Object?> get props => [
        status,
        userModel,
        books,
        totalPages,
        totalWords,
      ];
}
