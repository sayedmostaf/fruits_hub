import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/entities/review_entity.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';

class CustomReviewItem extends StatelessWidget {
  const CustomReviewItem({super.key, required this.reviewEntity});
  final ReviewEntity reviewEntity;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                reviewEntity.userName,
                style: AppTextStyle.textStyle16w600.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              Text(
                '${reviewEntity.createdAt.day}/${reviewEntity.createdAt.month}/${reviewEntity.createdAt.year}',
                style: AppTextStyle.textStyle13w400.copyWith(
                  color: Theme.of(context).textTheme.labelMedium?.color,
                ),
              ),
              SizedBox(height: 4),
              Text(
                reviewEntity.reviewDescription,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.textStyle13w400.copyWith(
                  color: Theme.of(context).textTheme.labelMedium?.color,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 51.45,
              height: 50.76,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: reviewEntity.imageUrl ?? '',
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
              ),
            ),
            Positioned(
              bottom: 4,
              right: -4,

              child: Container(
                width: 19.24,
                height: 19.28,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    '${reviewEntity.rating}',
                    style: AppTextStyle.textStyle11w600.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
