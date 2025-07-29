import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruits_hub/core/repos/images/images_repo.dart';
import 'package:fruits_hub/core/repos/images/images_repo_impl.dart';
import 'package:fruits_hub/core/repos/order/order_repo.dart';
import 'package:fruits_hub/core/repos/order/order_repo_impl.dart';
import 'package:fruits_hub/core/repos/product/product_repo.dart';
import 'package:fruits_hub/core/repos/product/product_repo_impl.dart';
import 'package:fruits_hub/core/services/database_service.dart';
import 'package:fruits_hub/core/services/firebase_auth_service.dart';
import 'package:fruits_hub/core/services/firestore_service.dart';
import 'package:fruits_hub/core/services/storage_service.dart';
import 'package:fruits_hub/core/services/supabase_storage_service.dart';
import 'package:fruits_hub/features/auth/data/repos/auth_repo_impl.dart';
import 'package:fruits_hub/features/auth/domain/repos/auth_repo.dart';
import 'package:fruits_hub/features/notifications/data/repos/notifications_repo_impl.dart';
import 'package:fruits_hub/features/notifications/domain/repos/notifications_repo.dart';
import 'package:fruits_hub/features/reviews/data/repos/reviews_repo_impl.dart';
import 'package:fruits_hub/features/reviews/domain/repos/reviews_repo.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
void setupLocator() {
  getIt.registerSingleton<StorageService>(SupabaseStorageService());
  getIt.registerSingleton<DatabaseService>(FirestoreService());
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());
  getIt.registerSingleton<AuthRepo>(
    AuthRepoImpl(
      databaseService: getIt.get<DatabaseService>(),
      firebaseAuthService: getIt.get<FirebaseAuthService>(),
    ),
  );
  getIt.registerSingleton<ProductRepo>(
    ProductRepoImpl(getIt.get<DatabaseService>()),
  );

  getIt.registerSingleton<OrderRepo>(
    OrderRepoImpl(databaseService: getIt.get<DatabaseService>()),
  );
  getIt.registerSingleton<ImagesRepo>(
    ImagesRepoImpl(storageService: getIt.get<StorageService>()),
  );
  getIt.registerSingleton<ReviewsRepo>(
    ReviewsRepoImpl(databaseService: getIt.get<DatabaseService>()),
  );
  getIt.registerSingleton<NotificationsRepo>(
    NotificationsRepoImpl(firestore: FirebaseFirestore.instance),
  );
}
