import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/entities/discount_entity.dart';
import 'package:fruits_hub/core/functions/get_saved_user_data.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';

class DiscountNotificationCard extends StatefulWidget {
  const DiscountNotificationCard({
    super.key,
    required this.discount,
    required this.relativeTime,
    this.onSwiped,
    this.onTap,
    this.isRead = false,
  });

  final DiscountEntity discount;
  final String relativeTime;
  final VoidCallback? onSwiped;
  final VoidCallback? onTap;
  final bool isRead;

  @override
  State<DiscountNotificationCard> createState() =>
      _DiscountNotificationCardState();
}

class _DiscountNotificationCardState extends State<DiscountNotificationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isDismissed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isDismissed) {
      return const SizedBox.shrink();
    }

    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: _buildDismissibleCard(context),
      ),
    );
  }

  Widget _buildDismissibleCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Dismissible(
        key: ValueKey(
          '${widget.discount.productCode}_${widget.discount.createdAt.toIso8601String()}',
        ),
        direction: DismissDirection.endToStart,
        dismissThresholds: const {DismissDirection.endToStart: 0.3},
        onDismissed: (_) {
          setState(() {
            _isDismissed = true;
          });
          widget.onSwiped?.call();
        },
        background: _buildSwipeBackground(context),
        child: _buildNotificationCard(context),
      ),
    );
  }

  Widget _buildSwipeBackground(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade600],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.mark_email_read_rounded, color: Colors.white, size: 28),
          const SizedBox(height: 4),
          Text(
            AppStrings.markedAsRead.tr(),
            style: AppTextStyle.textStyle12w500.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  widget.isRead
                      ? Theme.of(context).colorScheme.outline.withOpacity(0.2)
                      : _getDiscountColor().withOpacity(0.3),
              width: widget.isRead ? 1 : 2,
            ),
          ),
          child: Row(
            children: [
              _buildNotificationIcon(context),
              const SizedBox(width: 16),
              Expanded(child: _buildNotificationContent(context)),
              if (!widget.isRead) _buildUnreadIndicator(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getDiscountColor().withOpacity(0.1),
            _getDiscountColor().withOpacity(0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getDiscountColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(_getDiscountIcon(), color: _getDiscountColor(), size: 28),
          if (widget.discount.percentage >= 50)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                _getNotificationTitle(),
                style: AppTextStyle.textStyle16w600.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getDiscountColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${widget.discount.percentage.toInt()}% OFF',
                style: AppTextStyle.textStyle12w500.copyWith(
                  color: _getDiscountColor(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          widget.discount.note?.isNotEmpty == true
              ? widget.discount.note!
              : _getDefaultMessage(),
          style: AppTextStyle.textStyle14w400.copyWith(
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 14,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            const SizedBox(width: 4),
            Text(
              widget.relativeTime,
              style: AppTextStyle.textStyle12w400.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
            if (widget.discount.productCode.isNotEmpty) ...[
              const SizedBox(width: 16),
              Icon(
                Icons.local_offer_outlined,
                size: 14,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Code: ${widget.discount.productCode}',
                  style: AppTextStyle.textStyle12w400.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildUnreadIndicator(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: _getDiscountColor(),
        shape: BoxShape.circle,
      ),
    );
  }

  String _getNotificationTitle() {
    final percentage = widget.discount.percentage.toInt();
    if (percentage >= 70) return AppStrings.bigDiscount.tr();
    if (percentage >= 50) return AppStrings.bigSavingsAvailable.tr();
    if (percentage >= 30) return AppStrings.bigDiscountAlert.tr();
    if (percentage >= 20) return AppStrings.specialOffer.tr();
    return AppStrings.discountAvailable.tr();
  }

  String _getDefaultMessage() {
    return AppStrings.donTMissOutOnThisAmazingOffer.tr();
  }

  IconData _getDiscountIcon() {
    final percentage = widget.discount.percentage.toInt();
    if (percentage >= 70) return Icons.local_fire_department;
    if (percentage >= 50) return Icons.flash_on;
    if (percentage >= 30) return Icons.star;
    if (percentage >= 20) return Icons.local_offer;
    return Icons.discount;
  }

  Color _getDiscountColor() {
    final percentage = widget.discount.percentage.toInt();
    if (percentage >= 70) return Colors.red.shade600;
    if (percentage >= 50) return Colors.orange.shade600;
    if (percentage >= 30) return Colors.blue.shade600;
    if (percentage >= 20) return Colors.green.shade600;
    return Colors.grey.shade600;
  }

  bool get _isCurrentUserRead {
    final currentUserId = getSavedUserData().uid;
    return widget.discount.readBy.contains(currentUserId);
  }
}
