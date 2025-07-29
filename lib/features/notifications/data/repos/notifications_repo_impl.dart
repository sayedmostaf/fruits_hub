import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fruits_hub/core/entities/discount_entity.dart';
import 'package:fruits_hub/core/errors/failure.dart';
import 'package:fruits_hub/core/models/discount_model.dart';
import 'package:fruits_hub/core/utils/backend_endpoints.dart';
import 'package:fruits_hub/features/notifications/domain/repos/notifications_repo.dart';

class NotificationsRepoImpl implements NotificationsRepo {
  final FirebaseFirestore firestore;
  NotificationsRepoImpl({required this.firestore});

  @override
  Future<Either<Failure, List<DiscountEntity>>> fetchNotifications() async {
    try {
      final snapshot =
          await firestore
              .collection(BackendEndpoints.getNotificationsDiscounts)
              .get();
      final discounts =
          snapshot.docs.map((doc) {
            final json = doc.data();
            return DiscountModel.fromJson(json).copyWith(productCode: doc.id);
          }).toList();

      return right(discounts);
    } catch (e) {
      log('❌ Error fetching notifications: $e');
      return left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead(String uid) async {
    try {
      final collection = firestore.collection(
        BackendEndpoints.getNotificationsDiscounts,
      );
      final snapshot = await collection.get();

      for (final doc in snapshot.docs) {
        await doc.reference.update({
          'readBy': FieldValue.arrayUnion([uid]),
        });
      }
      return right(null);
    } catch (e) {
      log('❌ Error marking all notifications as read: $e');
      return left(
        ServerFailure(errMessage: 'Failed to mark notifications as read'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> markOneAsRead({
    required String discountId,
    required String uid,
  }) async {
    try {
      if (discountId.isEmpty) throw Exception('discount is empty');
      await firestore
          .collection(BackendEndpoints.getNotificationsDiscounts)
          .doc(discountId)
          .update({
            'readBy': FieldValue.arrayUnion([uid]),
          });
      return right(null);
    } catch (e) {
      log('❌ Error marking one notification as read: $e');
      return left(ServerFailure(errMessage: e.toString()));
    }
  }
}
