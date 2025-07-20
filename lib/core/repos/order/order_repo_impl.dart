import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fruits_hub/core/errors/failure.dart';
import 'package:fruits_hub/core/repos/order/order_repo.dart';
import 'package:fruits_hub/core/services/database_service.dart';
import 'package:fruits_hub/core/utils/backend_endpoints.dart';
import 'package:fruits_hub/features/checkout/data/models/order_model.dart';
import 'package:fruits_hub/features/checkout/domain/entities/order_entity.dart';

class OrderRepoImpl extends OrderRepo {
  final DatabaseService databaseService;
  OrderRepoImpl({required this.databaseService});
  @override
  Future<Either<Failure, void>> addOrder({
    required OrderEntity orderEntity,
  }) async {
    try {
      await databaseService.addDocument(
        path: BackendEndpoints.addOrders,
        data: OrderModel.fromEntity(orderEntity: orderEntity).toJson(),
      );
      log('OrdersRepoImpl.addOrder: ✅ Success');
      return right(null);
    } catch (e) {
      log('OrdersRepoImpl.addOrder: ❌ ${e.toString()}');
      return left(ServerFailure(errMessage: 'failed to add the order'));
    }
  }
}
