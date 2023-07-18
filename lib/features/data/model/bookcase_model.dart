import 'package:cloud_firestore/cloud_firestore.dart';

class BookcaseModel {
  String id;
  final String title;
  final List<String> bookIds;
  final String userId;
  final DateTime createdAt;

  BookcaseModel({
    required this.id,
    required this.title,
    required this.bookIds,
    required this.userId,
    required this.createdAt,
  });

  factory BookcaseModel.fromJson(Map<String, dynamic> json) {
    return BookcaseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      bookIds: List.from(json['book_ids'] as List<dynamic>),
      userId: json['user_id'] as String,
      createdAt: (json['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'book_ids': bookIds,
      'user_id': userId,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }
}
