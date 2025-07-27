import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fruits_hub/core/entities/review_entity.dart';
import 'package:fruits_hub/core/functions/build_error_snack_bar.dart';
import 'package:fruits_hub/core/functions/get_saved_user_data.dart';
import 'package:fruits_hub/core/models/review_model.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/core/utils/widgets/custom_text_form_field.dart';
import 'package:fruits_hub/features/reviews/presentation/managers/reviews_cubit.dart';
import 'package:provider/provider.dart';

class AddingReviewSection extends StatefulWidget {
  const AddingReviewSection({super.key});

  @override
  State<AddingReviewSection> createState() => _AddingReviewSectionState();
}

class _AddingReviewSectionState extends State<AddingReviewSection> {
  double _userRating = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  late String reviewDescription;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: autovalidateMode,
      child: Column(
        children: [
          CustomTextFormField(
            hintText: AppStrings.writeComment.tr(),
            textInputType: TextInputType.text,
            onSaved: (value) {
              reviewDescription = value!;
            },
            prefixIcon: FittedBox(
              fit: BoxFit.scaleDown,
              child: ClipOval(
                child: Image.network(
                  getSavedUserData().imageUrl ?? '',
                  fit: BoxFit.cover,
                  width: 30,
                  height: 30,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: Icon(
                          Icons.person,
                          color: Theme.of(context).textTheme.labelMedium?.color,
                        ),
                      ),
                ),
              ),
            ),
            suffixIcon: TextButton(
              onPressed: () {
                if (_userRating >= 1) {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final ReviewEntity review = ReviewEntity(
                      userId: getSavedUserData().uid,
                      userName: getSavedUserData().name,
                      createdAt: DateTime.now(),
                      rating: _userRating,
                      reviewDescription: reviewDescription,
                      imageUrl: getSavedUserData().imageUrl,
                    );
                    context.read<ReviewsCubit>().addReview(
                      review: ReviewModel.fromEntity(review),
                    );
                  } else {
                    autovalidateMode = AutovalidateMode.always;
                    setState(() {});
                  }
                } else {
                  buildErrorSnackBar(
                    context,
                    message: AppStrings.ratingMissing.tr(),
                  );
                }
              },
              child: Text(
                AppStrings.sendCode.tr(),
                style: AppTextStyle.textStyle16w600.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: RatingBar.builder(
              initialRating: _userRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 32,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder:
                  (context, _) => Icon(
                    Icons.star,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
              onRatingUpdate: (rating) {
                setState(() {
                  _userRating = rating;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
