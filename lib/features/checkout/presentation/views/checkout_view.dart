import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/functions/get_saved_user_data.dart';
import 'package:fruits_hub/core/repos/order/order_repo.dart';
import 'package:fruits_hub/core/services/app_locator.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/checkout/domain/entities/order_entity.dart';
import 'package:fruits_hub/features/checkout/presentation/manager/order/order_cubit.dart';
import 'package:fruits_hub/features/checkout/presentation/views/widgets/add_order_bloc_consumer_builder.dart';
import 'package:fruits_hub/features/checkout/presentation/views/widgets/checkout_view_body.dart';
import 'package:fruits_hub/features/shopping_cart/domain/entities/cart_entity.dart';
import 'package:provider/provider.dart';

class CheckoutView extends StatelessWidget {
  CheckoutView({super.key, required this.cart});
  final CartEntity cart;
  final ValueNotifier<int> pageIndexNotifier = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: _buildAppBar(context, theme),
      body: BlocProvider(
        create: (context) => OrderCubit(getIt.get<OrderRepo>()),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Provider<OrderEntity>(
            create: (_) => OrderEntity(cart: cart, uid: getSavedUserData().uid),
            child: AddOrderBlocConsumerBuilder(
              child: CheckoutViewBody(pageIndexNotifier: pageIndexNotifier),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_ios_new, color: theme.iconTheme.color),
      ),
      title: ValueListenableBuilder<int>(
        valueListenable: pageIndexNotifier,
        builder:
            (context, page, _) => Text(
              getCheckoutStepsText()[page].tr(),
              style: AppTextStyle.textStyle19w700.copyWith(
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
      ),
    );
  }
}
