import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fruits_hub/core/entities/review_entity.dart';
import 'package:fruits_hub/core/functions/build_error_snack_bar.dart';
import 'package:fruits_hub/core/functions/get_saved_user_data.dart';
import 'package:fruits_hub/core/models/review_model.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/reviews/presentation/managers/reviews_cubit.dart';
import 'package:provider/provider.dart';

class AddingReviewSection extends StatefulWidget {
  const AddingReviewSection({super.key});

  @override
  State<AddingReviewSection> createState() => _AddingReviewSectionState();
}

class _AddingReviewSectionState extends State<AddingReviewSection>
    with TickerProviderStateMixin {
  double _userRating = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _reviewController = TextEditingController();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  bool _isExpanded = false;
  bool _isSubmitting = false;

  late AnimationController _expandController;
  late AnimationController _ratingAnimationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _ratingScaleAnimation;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _ratingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );
    _ratingScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _ratingAnimationController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    _ratingAnimationController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(context),
          AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              return ClipRect(
                child: Align(
                  heightFactor: _isExpanded ? _expandAnimation.value : 0.0,
                  child: child,
                ),
              );
            },
            child: _buildReviewForm(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
        if (_isExpanded) {
          _expandController.forward();
        } else {
          _expandController.reverse();
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            _buildUserAvatar(context),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isExpanded
                        ? AppStrings.shareYourExperience.tr()
                        : AppStrings.addAReview.tr(),
                    style: AppTextStyle.textStyle16w600.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isExpanded
                        ? AppStrings.helpOthersBySharingYourThoughts.tr()
                        : AppStrings.tapToAddYourReview.tr(),
                    style: AppTextStyle.textStyle14w400.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar(BuildContext context) {
    final userData = getSavedUserData();

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: SizedBox(
          width: 48,
          height: 48,
          child:
              userData.imageUrl?.isNotEmpty == true
                  ? Image.network(
                    userData.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            _buildDefaultAvatar(context),
                  )
                  : _buildDefaultAvatar(context),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar(BuildContext context) {
    final userData = getSavedUserData();
    final initials =
        userData.name.isNotEmpty
            ? userData.name.substring(0, 1).toUpperCase()
            : 'U';

    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Center(
        child: Text(
          initials,
          style: AppTextStyle.textStyle16w600.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildReviewForm(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: autovalidateMode,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const SizedBox(height: 20),
            _buildRatingSection(context),
            const SizedBox(height: 24),
            _buildCommentSection(context),
            const SizedBox(height: 24),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.star_outline,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              AppStrings.rateYourExperience.tr(),
              style: AppTextStyle.textStyle14w600.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _ratingScaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _ratingScaleAnimation.value,
                    child: RatingBar.builder(
                      initialRating: _userRating,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 40,
                      glow: false,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 6.0),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color:
                                index < _userRating
                                    ? Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.1)
                                    : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.star,
                            color:
                                index < _userRating
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.outline,
                          ),
                        );
                      },
                      onRatingUpdate: (rating) {
                        setState(() {
                          _userRating = rating;
                        });
                        _ratingAnimationController.forward().then((_) {
                          _ratingAnimationController.reverse();
                        });
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              if (_userRating > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getRatingLabel(_userRating),
                    style: AppTextStyle.textStyle12w500.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.edit_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              AppStrings.writeYourReview.tr(),
              style: AppTextStyle.textStyle14w600.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _reviewController,
          maxLines: 4,
          maxLength: 500,
          decoration: InputDecoration(
            hintText: AppStrings.writeComment.tr(),
            hintStyle: AppTextStyle.textStyle14w400.copyWith(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            filled: true,
            fillColor: Theme.of(
              context,
            ).colorScheme.surfaceVariant.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            counterStyle: AppTextStyle.textStyle12w400.copyWith(
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return AppStrings.pleaseWriteYourReview.tr();
            }
            if (value.trim().length < 10) {
              return AppStrings.reviewMustBeAtLeast10Characters.tr();
            }
            return null;
          },
          onSaved: (value) {
            // Handle saving if needed
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _handleSubmitReview,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          elevation: _userRating > 0 ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: Theme.of(
            context,
          ).colorScheme.outline.withOpacity(0.3),
        ),
        child:
            _isSubmitting
                ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.send, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.sendReview.tr(),
                      style: AppTextStyle.textStyle16w600,
                    ),
                  ],
                ),
      ),
    );
  }

  Future<void> _handleSubmitReview() async {
    if (_userRating < 1) {
      buildErrorSnackBar(context, message: AppStrings.ratingMissing.tr());
      return;
    }

    if (!_formKey.currentState!.validate()) {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      _formKey.currentState!.save();
      final userData = getSavedUserData();

      final ReviewEntity review = ReviewEntity(
        userId: userData.uid,
        userName: userData.name,
        createdAt: DateTime.now(),
        rating: _userRating,
        reviewDescription: _reviewController.text.trim(),
        imageUrl: userData.imageUrl,
      );

      await context.read<ReviewsCubit>().addReview(
        review: ReviewModel.fromEntity(review),
      );

      // Reset form on success
      _resetForm();

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.reviewSubmittedSuccessfully.tr()),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        buildErrorSnackBar(
          context,
          message: AppStrings.failedToSubmitReviewPleaseTryAgain.tr(),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _resetForm() {
    setState(() {
      _userRating = 0;
      _reviewController.clear();
      autovalidateMode = AutovalidateMode.disabled;
      _isExpanded = false;
    });
    _expandController.reverse();
  }

  String _getRatingLabel(double rating) {
    if (rating >= 4.5) return AppStrings.excellent.tr();
    if (rating >= 3.5) return AppStrings.good.tr();
    if (rating >= 2.5) return AppStrings.average.tr();
    if (rating >= 1.5) return AppStrings.poor.tr();
    return AppStrings.terrible.tr();
  }
}
