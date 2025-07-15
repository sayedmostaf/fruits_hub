import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/cubits/products_cubit/products_cubit.dart';
import 'package:fruits_hub/core/repos/products_repo/products_repo.dart';
import 'package:fruits_hub/core/services/get_it_service.dart';
import 'package:fruits_hub/features/category/presentation/view/widgets/category_view_body.dart';
import 'package:flutter/material.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsCubit(getIt.get<ProductsRepo>()),
      child: CategoryViewBody(),
    );
  }
}
