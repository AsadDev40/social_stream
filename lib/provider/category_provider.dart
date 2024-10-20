import 'package:channelhub/model/category_model.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryProvider extends ChangeNotifier {

  //fetch categories
  Future<List<Categorymodel>> fetchCategories() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    return querySnapshot.docs.map((doc) {
      return Categorymodel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}
