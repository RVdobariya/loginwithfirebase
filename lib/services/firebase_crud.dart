import 'package:cloud_firestore/cloud_firestore.dart';

import '../response.dart';


final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _collection = _firestore.collection('Users');

class FirebaseCrud {

  static Future<Response> addUserData({
    required String number,
  }) async {

    Response response = Response();
    DocumentReference documentReferencer =
        _collection.doc();

    Map<String, dynamic> data = <String, dynamic>{
      "user_number": number,
   
    };

    var result = await documentReferencer
        .set(data)
        .whenComplete(() {
          response.code = 200;
          response.message = "Successfully added to the database";
        })
        .catchError((e) {
            response.code = 500;
            response.message = e;
        });

        return response;
  }



  static Future<Response> updateUserData({
    required String number,
       required String docId,   
  }) async {
    Response response = Response();
    DocumentReference documentReferencer =
        _collection.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "user_number": number,
  
    };

    await documentReferencer
        .update(data)
        .whenComplete(() {
           response.code = 200;
          response.message = "Successfully updated User";
        })
        .catchError((e) {
            response.code = 500;
            response.message = e;
        });

        return response;
  }

  static Stream<QuerySnapshot> readUserData() {
    CollectionReference notesItemCollection =
        _collection;

    return notesItemCollection.snapshots();
  }

  static Future<Response> deleteUserData({
    required String docId,
  }) async {
     Response response = Response();
    DocumentReference documentReferencer =
        _collection.doc(docId);

    await documentReferencer
        .delete()
        .whenComplete((){
          response.code = 200;
          response.message = "Successfully Deleted User";
        })
        .catchError((e) {
           response.code = 500;
            response.message = e;
        });

   return response;
  }

}