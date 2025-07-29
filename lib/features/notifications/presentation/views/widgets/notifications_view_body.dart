import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/entities/discount_entity.dart';
import 'package:fruits_hub/core/functions/build_success_snack_bar.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/core/utils/widgets/custom_section_header.dart';
import 'package:fruits_hub/features/notifications/presentation/managers/notifications_cubit.dart';
import 'package:fruits_hub/features/notifications/presentation/managers/notifications_state.dart';
import 'package:fruits_hub/features/notifications/presentation/views/widgets/discount_notification_card.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationsViewBody extends StatefulWidget {
  const NotificationsViewBody({super.key});

  @override
  State<NotificationsViewBody> createState() => _NotificationsViewBodyState();
}

class _NotificationsViewBodyState extends State<NotificationsViewBody> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        return CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  CustomSectionHeader(
                    title: AppStrings.notificationsNew.tr(),
                    subTitle: AppStrings.markAllAsRead.tr(),
                    count:
                        state is NotificationsSuccess
                            ? state.discounts.length
                            : 0,
                    onTap: () {
                      context.read<NotificationsCubit>().markAllAsRead();
                      buildSuccessSnackBar(
                        context,
                        message: AppStrings.markedAllAsRead.tr(),
                      );
                    },
                  ),
                ],
              ),
            ),
            if (state is NotificationsLoading)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverSkeletonizer(
                  child: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, __) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: DiscountNotificationCard(
                          discount: DummyDiscount(),
                          relativeTime: AppStrings.justNow.tr(),
                        ),
                      ),
                      childCount: 6,
                    ),
                  ),
                ),
              ),
            if (state is NotificationsSuccess && state.discounts.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    AppStrings.noNotifications.tr(),
                    style: AppTextStyle.textStyle16w700.copyWith(
                      color: textColor,
                    ),
                  ),
                ),
              ),
            if (state is NotificationsSuccess && state.discounts.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList.separated(
                  itemCount: state.discounts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    final discount = state.discounts[index];
                    final now = DateTime.now();
                    final diff = now.difference(discount.createdAt);
                    final relativeTime = _getRelativeTime(diff);

                    return DiscountNotificationCard(
                      discount: discount,
                      relativeTime: relativeTime,
                      onSwiped: () {
                        log('📦 Swipe on ${discount.productCode}');
                        context.read<NotificationsCubit>().markOneAsRead(
                          discount,
                        );
                      },
                    );
                  },
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        );
      },
    );
  }

  String _getRelativeTime(Duration diff) {
    if (diff.inMinutes < 1) return AppStrings.justNow.tr();
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} ${AppStrings.minutesAgo.tr()}';
    }
    if (diff.inHours < 24) return '${diff.inHours} ${AppStrings.hoursAgo.tr()}';
    return '${diff.inDays} ${AppStrings.daysAgo.tr()}';
  }
}

class DummyDiscount extends DiscountEntity {
  DummyDiscount()
    : super(
        note: '...',
        percentage: 0,
        createdAt: DateTime.now(),
        productCode: '',
        readBy: const [],
      );
}
