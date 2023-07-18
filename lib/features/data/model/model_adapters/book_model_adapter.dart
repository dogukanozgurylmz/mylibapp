import 'package:hive/hive.dart';

import '../book_model.dart';

class BookModelAdapter extends TypeAdapter<BookModel> {
  @override
  final int typeId = 1;

  @override
  BookModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    // final String id = reader.read();
    // final String bookName = reader.read();
    // final String author = reader.read();
    // final int page = reader.read();
    // final bool isReading = reader.read();
    // final DateTime endDate = reader.read();
    // final DateTime starterDate = reader.read();
    // final DateTime createdAt = reader.read();

    return BookModel(
      id: fields[0] as String,
      bookName: fields[1] as String,
      author: fields[2] as String,
      page: fields[3] as int,
      isReading: fields[4] as bool,
      starterDate: fields[5] as DateTime,
      endDate: fields[6] as DateTime,
      createdAt: fields[7] as DateTime,
      userId: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BookModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.bookName)
      ..writeByte(2)
      ..write(obj.author)
      ..writeByte(3)
      ..write(obj.page)
      ..writeByte(4)
      ..write(obj.isReading)
      ..writeByte(5)
      ..write(obj.starterDate)
      ..writeByte(6)
      ..write(obj.endDate)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.userId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
