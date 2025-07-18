import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/functions/build_best_selling_app_bar.dart';
import 'package:fruits_hub/core/managers/product/product_cubit.dart';
import 'package:fruits_hub/core/repos/product/product_repo.dart';
import 'package:fruits_hub/core/services/app_locator.dart';
import 'package:fruits_hub/features/best_selling/presentation/views/widgets/best_selling_view_body.dart';

class BestSellingView extends StatelessWidget {
  const BestSellingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBestSellingAppBar(context),
      body: BlocProvider(
        create:
            (context) =>
                ProductCubit(getIt.get<ProductRepo>())
                  ..getBestSellingProducts(),
        child: BestSellingViewBody(
        ),
      ),
    );
  }
}
