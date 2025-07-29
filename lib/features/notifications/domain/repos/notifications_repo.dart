import 'package:dartz/dartz.dart';
import 'package:fruits_hub/core/entities/discount_entity.dart';
import 'package:fruits_hub/core/errors/failure.dart';

abstract class NotificationsRepo {
  Future<Either<Failure, List<DiscountEntity>>> fetchNotifications();
  Future<Either<Failure, void>> markAllAsRead(String uid);
  Future<Either<Failure, void>> markOneAsRead({
    required String discountId,
    required String uid,
  });
}
