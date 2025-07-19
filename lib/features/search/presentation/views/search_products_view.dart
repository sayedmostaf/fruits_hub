import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/managers/product/product_cubit.dart';
import 'package:fruits_hub/core/repos/product/product_repo.dart';
import 'package:fruits_hub/core/services/app_locator.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/core/utils/widgets/notification_icon.dart';
import 'package:fruits_hub/features/search/presentation/views/widgets/search_products_view_body.dart';

class SearchProductsView extends StatelessWidget {
  const SearchProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildSearchAppBar(context),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => ProductCubit(getIt.get<ProductRepo>()),
          child: SearchProductsViewBody(),
        ),
      ),
    );
  }

  AppBar _buildSearchAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text(
        AppStrings.search.tr(),
        style: AppTextStyle.textStyle19w700.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(top: 8.0, left: 8),
          child: NotificationIcon(),
        ),
      ],
    );
  }
}
