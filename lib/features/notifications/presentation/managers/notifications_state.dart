import 'package:fruits_hub/core/entities/discount_entity.dart';

sealed class NotificationsState {}

final class NotificationsInitial extends NotificationsState {}

final class NotificationsLoading extends NotificationsState {}

final class NotificationsSuccess extends NotificationsState {
  final List<DiscountEntity> discounts;
  NotificationsSuccess(this.discounts);
}

final class NotificationsFailure extends NotificationsState {
  final String error;
  NotificationsFailure(this.error);
}

final class NotificationSwitchChanged extends NotificationsState {
  final bool enabled;
  NotificationSwitchChanged(this.enabled);
}
