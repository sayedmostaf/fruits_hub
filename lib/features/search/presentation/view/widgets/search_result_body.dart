import 'package:flutter/material.dart';
import 'package:fruits_hub/core/widgets/custom_app_bar.dart';
import 'package:fruits_hub/core/widgets/search_text_field.dart';
import 'package:fruits_hub/features/search/presentation/view/widgets/search_result_grid.dart';

class SearchResultBody extends StatelessWidget {
  const SearchResultBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverToBoxAdapter(child: buildAppBar(context, title: 'البحث')),
          SliverToBoxAdapter(child: SearchTextField()),
          SliverToBoxAdapter(child: SizedBox(height: 16)),
          SearchResultGrid(),
        ],
      ),
    );
  }
}
