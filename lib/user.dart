import 'package:mongo_dart/mongo_dart.dart';

class User1 {
  final ObjectId id;
  final String name;
  final int age;
  final int phone;

  const User1(this.id, this.name, this.age, this.phone);

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'age': age,
      'phone': phone,
    };
  }

  User1.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        id = map['_id'],
        age = map['age'],
        phone = map['phone'];
}
