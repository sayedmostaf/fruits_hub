import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/entities/review_entity.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:intl/intl.dart';

class CustomReviewItem extends StatelessWidget {
  const CustomReviewItem({
    super.key,
    required this.reviewEntity,
    this.isExpanded = false,
    this.onTap,
  });

  final ReviewEntity reviewEntity;
  final bool isExpanded;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 12),
                _buildRatingSection(context),
                const SizedBox(height: 12),
                _buildReviewContent(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        _buildUserAvatar(context),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      reviewEntity.userName.isNotEmpty
                          ? reviewEntity.userName
                          : 'Anonymous User',
                      style: AppTextStyle.textStyle16w600.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (_isRecentReview())
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'New',
                        style: AppTextStyle.textStyle11w600.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(reviewEntity.createdAt),
                    style: AppTextStyle.textStyle12w400.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserAvatar(BuildContext context) {
    final hasImage = reviewEntity.imageUrl?.isNotEmpty == true;
    final initials =
        reviewEntity.userName.isNotEmpty
            ? reviewEntity.userName.substring(0, 1).toUpperCase()
            : 'U';

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: _getRatingColor(context).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: _getRatingColor(context).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child:
            hasImage
                ? CachedNetworkImage(
                  imageUrl: reviewEntity.imageUrl!,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) =>
                          _buildAvatarPlaceholder(context, initials),
                  errorWidget:
                      (context, url, error) =>
                          _buildAvatarPlaceholder(context, initials),
                )
                : _buildAvatarPlaceholder(context, initials),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(BuildContext context, String initials) {
    return Container(
      color: _getRatingColor(context).withOpacity(0.1),
      child: Center(
        child: Text(
          initials,
          style: AppTextStyle.textStyle16w600.copyWith(
            color: _getRatingColor(context),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSection(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getRatingColor(context).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, size: 16, color: _getRatingColor(context)),
              const SizedBox(width: 4),
              Text(
                reviewEntity.rating.toString(),
                style: AppTextStyle.textStyle12w500.copyWith(
                  color: _getRatingColor(context),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: _buildStarRating(context)),
        Text(
          _getRatingLabel(),
          style: AppTextStyle.textStyle12w500.copyWith(
            color: _getRatingColor(context),
          ),
        ),
      ],
    );
  }

  Widget _buildStarRating(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final isFilled = index < reviewEntity.rating.floor();
        final isHalfFilled =
            index == reviewEntity.rating.floor() &&
            reviewEntity.rating % 1 != 0;

        return Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Stack(
            children: [
              Icon(
                Icons.star_outline,
                size: 16,
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
              if (isFilled)
                Icon(Icons.star, size: 16, color: _getRatingColor(context))
              else if (isHalfFilled)
                ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.5,
                    child: Icon(
                      Icons.star,
                      size: 16,
                      color: _getRatingColor(context),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildReviewContent(BuildContext context) {
    final hasContent = reviewEntity.reviewDescription.trim().isNotEmpty;

    if (!hasContent) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 16,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            const SizedBox(width: 8),
            Text(
              'No written review',
              style: AppTextStyle.textStyle13w400.copyWith(
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
            ),
          ),
          child: Text(
            reviewEntity.reviewDescription,
            maxLines: isExpanded ? null : 4,
            overflow: isExpanded ? null : TextOverflow.ellipsis,
            style: AppTextStyle.textStyle14w400.copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              height: 1.4,
            ),
          ),
        ),
        if (_shouldShowReadMore() && onTap != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                isExpanded ? 'Read less' : 'Read more',
                style: AppTextStyle.textStyle12w500.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Color _getRatingColor(BuildContext context) {
    if (reviewEntity.rating >= 4) {
      return Colors.green;
    } else if (reviewEntity.rating >= 3) {
      return Colors.orange;
    } else if (reviewEntity.rating >= 2) {
      return Colors.red.shade600;
    } else {
      return Colors.red.shade800;
    }
  }

  String _getRatingLabel() {
    if (reviewEntity.rating >= 4.5) return 'Excellent';
    if (reviewEntity.rating >= 3.5) return 'Good';
    if (reviewEntity.rating >= 2.5) return 'Average';
    if (reviewEntity.rating >= 1.5) return 'Poor';
    return 'Terrible';
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  bool _isRecentReview() {
    final now = DateTime.now();
    final difference = now.difference(reviewEntity.createdAt);
    return difference.inDays <= 7; // Consider reviews from last 7 days as "new"
  }

  bool _shouldShowReadMore() {
    return reviewEntity.reviewDescription.length >
        200; // Show read more if text is long
  }
}
