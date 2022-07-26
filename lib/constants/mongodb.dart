import 'package:mongo_dart/mongo_dart.dart';

import '../user.dart';
import 'constants.dart';




class MongoDatabase {
  static var db, userCollection;

  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    userCollection = db.collection(USER_COLLECCTION);
  }

  static Future<List<Map<String, dynamic>>> getDocuments() async {
    
      final users = await userCollection.find().toList();
      return users;
  }
  

  static insert(User1 user) async {
    await userCollection.insertAll([user.toMap()]);
  }


  }


