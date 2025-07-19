import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruits_hub/core/services/database_service.dart';

class FirestoreService implements DatabaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Future<void> addDocument({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  }) async {
    if (documentId != null) {
      await firestore.collection(path).doc(documentId).set(data);
    } else {
      await firestore.collection(path).add(data);
    }
  }

  @override
  Future<bool> isDocumentExist({
    required String path,
    required documentId,
  }) async {
    var doc = await firestore.collection(path).doc(documentId).get();
    return doc.exists;
  }

  @override
  Future getDocumentOrCollection({
    required String path,
    String? documentId,
    Map<String, dynamic>? queries,
  }) async {
    if (documentId != null) {
      final doc = await firestore.collection(path).doc(documentId).get();
      return doc.data();
    }

    Query<Map<String, dynamic>> collection = firestore.collection(path);

    if (queries != null) {
      queries.forEach((key, value) {
        if (key == 'where' && value is List) {
          for (var condition in value) {
            collection = collection.where(
              condition['field'],
              isEqualTo:
                  condition['operator'] == '==' ? condition['value'] : null,
              isGreaterThan:
                  condition['operator'] == '>' ? condition['value'] : null,
              isLessThan:
                  condition['operator'] == '<' ? condition['value'] : null,
              isGreaterThanOrEqualTo:
                  condition['operator'] == '>=' ? condition['value'] : null,
              isLessThanOrEqualTo:
                  condition['operator'] == '<=' ? condition['value'] : null,
              isNotEqualTo:
                  condition['operator'] == '!=' ? condition['value'] : null,
              arrayContains:
                  condition['operator'] == 'arrayContains'
                      ? condition['value']
                      : null,
              arrayContainsAny:
                  condition['operator'] == 'arrayContainsAny'
                      ? condition['value']
                      : null,
              whereIn:
                  condition['operator'] == 'in' ? condition['value'] : null,
              whereNotIn:
                  condition['operator'] == 'not-in' ? condition['value'] : null,
            );
          }
        }

        if (key == 'orderBy') {
          bool descending = queries['descending'] ?? false;
          collection = collection.orderBy(value, descending: descending);
        }

        if (key == 'limit') {
          collection = collection.limit(value);
        }
      });
    }

    final data = await collection.get();
    return data.docs.map((doc) => doc.data()).toList();
  }
}
