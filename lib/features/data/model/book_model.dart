import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class BookModel {
  @HiveField(0)
  String id;
  @HiveField(1)
  final String bookName;
  @HiveField(2)
  final String author;
  @HiveField(3)
  final int page;
  @HiveField(4)
  final bool isReading;
  @HiveField(5)
  final DateTime starterDate;
  @HiveField(6)
  final DateTime endDate;
  @HiveField(7)
  final DateTime createdAt;
  @HiveField(8)
  final String userId;

  BookModel({
    required this.id,
    required this.bookName,
    required this.author,
    required this.page,
    required this.isReading,
    required this.starterDate,
    required this.endDate,
    required this.createdAt,
    required this.userId,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json["id"] as String,
      bookName: json['book_name'] as String,
      author: json['author'] as String,
      page: json['page'] as int,
      isReading: json['is_reading'] as bool,
      starterDate: (json['starter_date'] as Timestamp).toDate(),
      endDate: (json['end_date'] as Timestamp).toDate(),
      createdAt: (json['created_at'] as Timestamp).toDate(),
      userId: json['user_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'book_name': bookName,
      'author': author,
      'page': page,
      'is_reading': isReading,
      'starter_date': Timestamp.fromDate(starterDate),
      'end_date': Timestamp.fromDate(endDate),
      'created_at': Timestamp.fromDate(createdAt),
      'user_id': userId,
    };
  }
}
