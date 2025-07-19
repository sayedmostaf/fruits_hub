import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/manager/cart/cart_cubit.dart';
import 'package:fruits_hub/features/shopping_cart/presentation/manager/cart/cart_state.dart';

AppBar buildCartAppBar(BuildContext context) {
  return AppBar(
    centerTitle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    elevation: 0,
    actions: [
      BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          return Visibility(
            visible: context.read<CartCubit>().cart.cartItems.isNotEmpty,
            child: Container(
              margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
              width: 40,
              height: 40,
              child: Material(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    context.read<CartCubit>().clearCart();
                  },
                  child: Center(
                    child: SvgPicture.asset(
                      Assets.imagesTrash,
                      width: 20,
                      height: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ],
    title: Text(
      AppStrings.cart.tr(),
      style: AppTextStyle.textStyle18w700.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}
