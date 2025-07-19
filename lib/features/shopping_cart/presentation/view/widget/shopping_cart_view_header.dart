import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/manager/cart/cart_cubit.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/manager/cart/cart_state.dart';

class ShoppingCartViewHeader extends StatelessWidget {
  const ShoppingCartViewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
      ),
      child: Center(
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            final itemCount = context.watch<CartCubit>().cart.cartItems.length;
            return Text(
              plural(AppStrings.cartItemsCount, itemCount),
              style: AppTextStyle.textStyle13w400.copyWith(
                color: theme.colorScheme.primary,
              ),
            );
          },
        ),
      ),
    );
  }
}
