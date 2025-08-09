import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/entities/discount_entity.dart';
import 'package:fruits_hub/core/functions/get_saved_user_data.dart';
import 'package:fruits_hub/core/services/shared_preferences.dart';
import 'package:fruits_hub/core/utils/constants.dart';
import 'package:fruits_hub/features/notifications/domain/repos/notifications_repo.dart';
import 'package:fruits_hub/features/notifications/presentation/managers/notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepo notificationsRepo;
  bool notificationsEnabled = true;
  NotificationsCubit({required this.notificationsRepo})
    : super(NotificationsInitial()) {
    _init();
  }

  Future<void> _init() async {
    notificationsEnabled = Pref.getBool(Constants.notificationKey) ?? true;
    _handleFcmSubscription(notificationsEnabled);
    emit(NotificationSwitchChanged(notificationsEnabled));
    fetchNotifications();
  }

  Future<void> _handleFcmSubscription(bool subscribe) async {
    final topic = getSavedUserData().uid;
    if (subscribe) {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    }
  }

  Future<void> fetchNotifications() async {
    emit(NotificationsLoading());
    final result = await notificationsRepo.fetchNotifications();
    result.fold((failure) => emit(NotificationsFailure(failure.errMessage)), (
      discounts,
    ) {
      // ✅ FIX: Return ALL notifications, let UI handle filtering
      emit(NotificationsSuccess(discounts));
    });
  }

  Future<void> markOneAsRead(DiscountEntity discount) async {
    final uid = getSavedUserData().uid;

    final result = await notificationsRepo.markOneAsRead(
      discountId: discount.productCode,
      uid: uid,
    );
    result.fold((_) {}, (_) {
      final currentState = state;
      if (currentState is NotificationsSuccess) {
        // ✅ FIX: Update the discount in the list instead of removing it
        final updatedList =
            currentState.discounts.map((e) {
              if (e.productCode == discount.productCode) {
                // Create a new instance with updated readBy list
                final updatedReadBy = List<String>.from(e.readBy);
                if (!updatedReadBy.contains(uid)) {
                  updatedReadBy.add(uid);
                }
                return e.copyWith(readBy: updatedReadBy);
              }
              return e;
            }).toList();

        emit(NotificationsSuccess(updatedList));
      }
    });
  }

  Future<void> markAllAsRead() async {
    final uid = getSavedUserData().uid;
    final result = await notificationsRepo.markAllAsRead(uid);
    result.fold((failure) => emit(NotificationsFailure(failure.errMessage)), (
      _,
    ) {
      // ✅ FIX: Update all notifications instead of clearing the list
      final currentState = state;
      if (currentState is NotificationsSuccess) {
        final updatedList =
            currentState.discounts.map((discount) {
              final updatedReadBy = List<String>.from(discount.readBy);
              if (!updatedReadBy.contains(uid)) {
                updatedReadBy.add(uid);
              }
              return discount.copyWith(readBy: updatedReadBy);
            }).toList();

        emit(NotificationsSuccess(updatedList));
      }
    });
  }

  Future<void> toggleNotifications(bool value) async {
    notificationsEnabled = value;
    await Pref.setBool(Constants.notificationKey, value);

    await _handleFcmSubscription(value);
    emit(NotificationSwitchChanged(notificationsEnabled));
    Future.delayed(Duration(milliseconds: 400), () {
      fetchNotifications();
    });
  }
}
