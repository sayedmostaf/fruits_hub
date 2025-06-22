import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/models/product_model.dart';
import 'package:fruits_hub/features/home/presentation/cubits/cart_cubit/cart_cubit.dart';
import 'package:fruits_hub/features/product_details/presentation/view/widgets/product_details_view_body.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key, required this.productModel});

  static const routeName = 'product_details_view';
  final ProductModel productModel;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubit(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: ProductDetailsViewBody(productModel: productModel),
        ),
      ),
    );
  }
}
