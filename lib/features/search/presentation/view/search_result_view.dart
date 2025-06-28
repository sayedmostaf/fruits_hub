import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/repos/products_repo/products_repo.dart';
import 'package:fruits_hub/core/services/get_it_service.dart';
import 'package:fruits_hub/features/search/presentation/cubit/search_cubit.dart';
import 'package:fruits_hub/features/search/presentation/view/widgets/search_result_body.dart';

class SearchResultView extends StatelessWidget {
  const SearchResultView({super.key});
  static const String routeName = '/searchResult';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchCubit>(
      create: (context) => SearchCubit(getIt.get<ProductsRepo>()),
      child: SafeArea(child: Scaffold(body: SearchResultBody())),
    );
  }
}
