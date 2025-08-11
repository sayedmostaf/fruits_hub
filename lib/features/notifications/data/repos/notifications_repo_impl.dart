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
          await firestore.collection(BackendEndpoints.getProducts).get();

      final discounts =
          snapshot.docs
              .map((doc) {
                final discountData = doc.data()['discount'];
                if (discountData == null || discountData is! Map) {
                  return null;
                }

                final discountJson = Map<String, dynamic>.from(discountData);
                return DiscountModel.fromJson(
                  discountJson,
                ).copyWith(productCode: doc.id);
              })
              .whereType<DiscountModel>()
              .toList();

      return right(discounts);
    } catch (e, stack) {
      log('❌ Error fetching notifications: $e\n$stack');
      return left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead(String uid) async {
    try {
      final snapshot = await firestore.collection(BackendEndpoints.getProducts).get();

      for (final doc in snapshot.docs) {
        if (doc.data().containsKey('discount')) {
          await doc.reference.update({
            'discount.readBy': FieldValue.arrayUnion([uid]),
          });
        }
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
      if (discountId.isEmpty) throw Exception('discountId is empty');

      final docRef = firestore.collection('Products').doc(discountId);

      final doc = await docRef.get();
      if (!doc.exists || !doc.data()!.containsKey('discount')) {
        throw Exception('Discount not found');
      }

      await docRef.update({
        'discount.readBy': FieldValue.arrayUnion([uid]),
      });

      return right(null);
    } catch (e) {
      log('❌ Error marking one notification as read: $e');
      return left(ServerFailure(errMessage: e.toString()));
    }
  }
}
