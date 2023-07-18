class SummaryModel {
  String id;
  final String bookId;
  final String summary;

  SummaryModel({
    required this.id,
    required this.bookId,
    required this.summary,
  });

  factory SummaryModel.fromJson(Map<String, dynamic> json) {
    return SummaryModel(
      id: json["id"] as String,
      bookId: json['book_id'] as String,
      summary: json['summary'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'book_id': bookId,
      'summary': summary,
    };
  }
}
