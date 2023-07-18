import 'package:hive/hive.dart';

import '../user_model.dart';

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final id = reader.read();
    final fullname = reader.read();
    final photoUrl = reader.read();
    final email = reader.read();
    final createdAt = reader.read();

    return UserModel(
      id: id,
      fullName: fullname,
      photoUrl: photoUrl,
      email: email,
      createdAt: createdAt,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer.write(obj.id);
    writer.write(obj.fullName);
    writer.write(obj.photoUrl);
    writer.write(obj.email);
    writer.write(obj.createdAt);
  }
}
