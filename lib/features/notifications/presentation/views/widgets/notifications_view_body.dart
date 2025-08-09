import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/entities/discount_entity.dart';
import 'package:fruits_hub/core/functions/build_success_snack_bar.dart';
import 'package:fruits_hub/core/functions/get_saved_user_data.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/core/utils/widgets/custom_section_header.dart';
import 'package:fruits_hub/features/notifications/presentation/managers/notifications_cubit.dart';
import 'package:fruits_hub/features/notifications/presentation/managers/notifications_state.dart';
import 'package:fruits_hub/features/notifications/presentation/views/widgets/discount_notification_card.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

enum NotificationFilter { all, unread, read }

enum NotificationSort { newest, oldest }

class NotificationsViewBody extends StatefulWidget {
  const NotificationsViewBody({super.key});

  @override
  State<NotificationsViewBody> createState() => _NotificationsViewBodyState();
}

class _NotificationsViewBodyState extends State<NotificationsViewBody>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  NotificationFilter _currentFilter = NotificationFilter.all;
  NotificationSort _currentSort = NotificationSort.newest;
  bool _isSelectionMode = false;
  final Set<String> _selectedNotifications = {};

  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    );

    context.read<NotificationsCubit>().fetchNotifications();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<NotificationsCubit, NotificationsState>(
      listener: _handleStateChanges,
      builder: (context, state) => _buildContent(context, state),
    );
  }

  void _handleStateChanges(BuildContext context, NotificationsState state) {
    if (state is NotificationsSuccess) {
      buildSuccessSnackBar(context, message: AppStrings.markedAllAsRead.tr());
    } else if (state is NotificationsSuccess) {
      buildSuccessSnackBar(
        context,
        message: 'Notification marked as read'.tr(),
      );
    } else if (state is NotificationsFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.error ?? 'Something went wrong'.tr()),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildContent(BuildContext context, NotificationsState state) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<NotificationsCubit>().fetchNotifications();
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            _buildAppBarSection(context, state),
            _buildFilterAndSortSection(context),
            _buildNotificationsList(context, state),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButtons(context, state),
    );
  }

  Widget _buildAppBarSection(BuildContext context, NotificationsState state) {
    final unreadCount = _getUnreadCount(state);

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            CustomSectionHeader(
              title: AppStrings.notificationsNew.tr(),
              subTitle:
                  _isSelectionMode
                      ? '${_selectedNotifications.length} selected'
                      : AppStrings.markAllAsRead.tr(),
              count: unreadCount,
              onTap:
                  _isSelectionMode
                      ? _exitSelectionMode
                      : () => _markAllAsRead(context),
            ),
            if (_isSelectionMode) _buildSelectionActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionActions(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            context,
            icon: Icons.mark_email_read,
            label: 'Mark Read',
            onPressed:
                _selectedNotifications.isNotEmpty
                    ? () => _markSelectedAsRead(context)
                    : null,
          ),
          _buildActionButton(
            context,
            icon: Icons.delete_outline,
            label: 'Delete',
            onPressed:
                _selectedNotifications.isNotEmpty
                    ? () => _deleteSelected(context)
                    : null,
          ),
          _buildActionButton(
            context,
            icon: Icons.select_all,
            label: 'Select All',
            onPressed: () => _selectAll(context),
          ),
          _buildActionButton(
            context,
            icon: Icons.close,
            label: 'Cancel',
            onPressed: _exitSelectionMode,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    final isEnabled = onPressed != null;
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color:
                isEnabled
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
          ),
          style: IconButton.styleFrom(
            backgroundColor:
                isEnabled
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.surfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label.tr(),
          style: AppTextStyle.textStyle11w600.copyWith(
            color:
                isEnabled
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterAndSortSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(
                      context,
                      NotificationFilter.all,
                      'All',
                      Icons.notifications,
                    ),
                    _buildFilterChip(
                      context,
                      NotificationFilter.unread,
                      'Unread',
                      Icons.mark_email_unread,
                    ),
                    _buildFilterChip(
                      context,
                      NotificationFilter.read,
                      'Read',
                      Icons.mark_email_read,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            _buildSortButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    NotificationFilter filter,
    String label,
    IconData icon,
  ) {
    final isSelected = _currentFilter == filter;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 4),
            Text(label.tr()),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _currentFilter = filter;
              _selectedNotifications.clear();
              _isSelectionMode = false;
            });
          }
        },
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
        checkmarkColor: Theme.of(context).colorScheme.primary,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _buildSortButton(BuildContext context) {
    return PopupMenuButton<NotificationSort>(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _currentSort == NotificationSort.newest
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              _currentSort == NotificationSort.newest ? 'Newest' : 'Oldest',
              style: AppTextStyle.textStyle12w500,
            ).tr(),
          ],
        ),
      ),
      onSelected: (sort) {
        setState(() {
          _currentSort = sort;
        });
      },
      itemBuilder:
          (context) => [
            PopupMenuItem(
              value: NotificationSort.newest,
              child: Row(
                children: [
                  const Icon(Icons.arrow_downward, size: 16),
                  const SizedBox(width: 8),
                  Text('Newest First'.tr()),
                ],
              ),
            ),
            PopupMenuItem(
              value: NotificationSort.oldest,
              child: Row(
                children: [
                  const Icon(Icons.arrow_upward, size: 16),
                  const SizedBox(width: 8),
                  Text('Oldest First'.tr()),
                ],
              ),
            ),
          ],
    );
  }

  Widget _buildNotificationsList(
    BuildContext context,
    NotificationsState state,
  ) {
    if (state is NotificationsLoading) {
      return _buildLoadingState();
    }

    if (state is NotificationsSuccess) {
      final filteredNotifications = _getFilteredNotifications(state.discounts);

      if (filteredNotifications.isEmpty) {
        return _buildEmptyState(context);
      }

      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverList.separated(
          itemCount: filteredNotifications.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder:
              (_, index) =>
                  _buildNotificationItem(context, filteredNotifications[index]),
        ),
      );
    }

    if (state is NotificationsFailure) {
      return _buildErrorState(context, state.error);
    }

    return _buildLoadingState();
  }

  Widget _buildNotificationItem(BuildContext context, DiscountEntity discount) {
    final isSelected = _selectedNotifications.contains(discount.productCode);
    final isRead = _isNotificationRead(discount);

    return GestureDetector(
      onLongPress: () => _enterSelectionMode(discount.productCode),
      onTap:
          _isSelectionMode
              ? () => _toggleSelection(discount.productCode)
              : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          border:
              _isSelectionMode && isSelected
                  ? Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  )
                  : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            DiscountNotificationCard(
              discount: discount,
              relativeTime: _getRelativeTime(
                DateTime.now().difference(discount.createdAt),
              ),
              isRead: isRead,
              onSwiped: () => _markSingleAsRead(context, discount),
              onTap: () {
                if (_isSelectionMode) {
                  _toggleSelection(discount.productCode);
                } else if (!isRead) {
                  _markSingleAsRead(context, discount);
                }
              },
            ),
            if (_isSelectionMode)
              Positioned(
                top: 8,
                right: 8,
                child: AnimatedScale(
                  scale: isSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SliverPadding(
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
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    String message;
    IconData icon;

    switch (_currentFilter) {
      case NotificationFilter.unread:
        message = 'No unread notifications';
        icon = Icons.mark_email_read;
        break;
      case NotificationFilter.read:
        message = 'No read notifications';
        icon = Icons.mark_email_unread;
        break;
      default:
        message = AppStrings.noNotifications.tr();
        icon = Icons.notifications_off;
    }

    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceVariant.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 48,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                message,
                style: AppTextStyle.textStyle18w700.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ).tr(),
              const SizedBox(height: 8),
              Text(
                'Pull down to refresh or check back later',
                textAlign: TextAlign.center,
                style: AppTextStyle.textStyle14w400.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ).tr(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String? message) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
              const SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: AppTextStyle.textStyle18w700,
              ).tr(),
              const SizedBox(height: 8),
              Text(
                message ?? 'Unable to load notifications',
                textAlign: TextAlign.center,
                style: AppTextStyle.textStyle14w400.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ).tr(),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed:
                    () =>
                        context.read<NotificationsCubit>().fetchNotifications(),
                icon: const Icon(Icons.refresh),
                label: Text('Try Again'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButtons(
    BuildContext context,
    NotificationsState state,
  ) {
    if (state is! NotificationsSuccess || state.discounts.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _fabAnimation,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_getUnreadCount(state) > 0)
              FloatingActionButton.small(
                heroTag: "mark_all",
                onPressed: () => _markAllAsRead(context),
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                foregroundColor: Theme.of(context).colorScheme.secondary,
                child: const Icon(Icons.done_all),
              ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: "selection_mode",
              onPressed: _toggleSelectionMode,
              backgroundColor:
                  _isSelectionMode
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary,
              child: Icon(_isSelectionMode ? Icons.close : Icons.checklist),
            ),
          ],
        );
      },
    );
  }

  // Helper methods
  List<DiscountEntity> _getFilteredNotifications(
    List<DiscountEntity> notifications,
  ) {
    List<DiscountEntity> filtered = notifications;

    // Apply filter
    switch (_currentFilter) {
      case NotificationFilter.unread:
        filtered = filtered.where((n) => !_isNotificationRead(n)).toList();
        break;
      case NotificationFilter.read:
        filtered = filtered.where((n) => _isNotificationRead(n)).toList();
        break;
      case NotificationFilter.all:
        break;
    }

    // Apply sort
    switch (_currentSort) {
      case NotificationSort.newest:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case NotificationSort.oldest:
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }

    return filtered;
  }

  bool _isNotificationRead(DiscountEntity discount) {
    final currentUserId = getSavedUserData().uid;
    return discount.readBy.contains(currentUserId);
  }

  int _getUnreadCount(NotificationsState state) {
    if (state is NotificationsSuccess) {
      return state.discounts.where((n) => !_isNotificationRead(n)).length;
    }
    return 0;
  }

  void _enterSelectionMode(String notificationId) {
    setState(() {
      _isSelectionMode = true;
      _selectedNotifications.add(notificationId);
    });
    _fabAnimationController.forward();
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedNotifications.clear();
    });
    _fabAnimationController.reverse();
  }

  void _toggleSelectionMode() {
    if (_isSelectionMode) {
      _exitSelectionMode();
    } else {
      setState(() {
        _isSelectionMode = true;
      });
      _fabAnimationController.forward();
    }
  }

  void _toggleSelection(String notificationId) {
    setState(() {
      if (_selectedNotifications.contains(notificationId)) {
        _selectedNotifications.remove(notificationId);
      } else {
        _selectedNotifications.add(notificationId);
      }
    });
  }

  void _selectAll(BuildContext context) {
    final state = context.read<NotificationsCubit>().state;
    if (state is NotificationsSuccess) {
      setState(() {
        _selectedNotifications.clear();
        _selectedNotifications.addAll(
          state.discounts.map((d) => d.productCode),
        );
      });
    }
  }

  void _markAllAsRead(BuildContext context) {
    context.read<NotificationsCubit>().markAllAsRead();
  }

  void _markSingleAsRead(BuildContext context, DiscountEntity discount) {
    context.read<NotificationsCubit>().markOneAsRead(discount);
  }

  void _markSelectedAsRead(BuildContext context) {
    final cubit = context.read<NotificationsCubit>();
    for (final id in _selectedNotifications) {
      final state = cubit.state;
      if (state is NotificationsSuccess) {
        final discount = state.discounts.firstWhere((d) => d.productCode == id);
        cubit.markOneAsRead(discount);
      }
    }
    _exitSelectionMode();
  }

  void _deleteSelected(BuildContext context) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Notifications'.tr()),
            content: Text(
              'Are you sure you want to delete the selected notifications?'
                  .tr(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'.tr()),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // TODO: Implement delete functionality
                  _exitSelectionMode();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Notifications deleted'.tr()),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: Text('Delete'.tr()),
              ),
            ],
          ),
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
