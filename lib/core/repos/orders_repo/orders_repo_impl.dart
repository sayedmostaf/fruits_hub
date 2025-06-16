import 'package:dartz/dartz.dart';
import 'package:fruits_hub/core/errors/failures.dart';
import 'package:fruits_hub/core/repos/orders_repo/orders_repo.dart';
import 'package:fruits_hub/core/services/data_service.dart';
import 'package:fruits_hub/core/utils/backend_endpoint.dart';
import 'package:fruits_hub/features/checkout/domain/entities/order_entity.dart';
import 'package:fruits_hub/features/checkout/models/order_model.dart';

class OrdersRepoImpl implements OrdersRepo {
  final DatabaseService firestoreService;
  OrdersRepoImpl(this.firestoreService);
  @override
  Future<Either<Failure, void>> addOrder({required OrderEntity order}) async {
    try {
      await firestoreService.addData(
        path: BackendEndpoint.addOrder,
        data: OrderModel.fromEntity(order).toJson(),
      );
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
