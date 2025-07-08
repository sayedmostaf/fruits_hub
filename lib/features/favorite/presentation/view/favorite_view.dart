import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruits_hub/core/services/get_it_service.dart';
import 'package:fruits_hub/features/favorite/presentation/manager/cubit/favorite_cubit.dart';
import 'package:fruits_hub/features/favorite/presentation/view/widgets/favorite_view_body.dart';

import '../../data/repo/favorite_repo.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});
  static const String routeName = '/favoriteView';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteCubit(getIt.get<FavoriteRepo>()),
      child: SafeArea(child: Scaffold(body: FavoriteViewBody())),
    );
  }
}
