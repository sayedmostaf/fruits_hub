import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fruits_hub/core/locale/recent_searche/recent_search_local_repo.dart';
import 'package:fruits_hub/core/locale/recent_searche/recent_search_local_repo_impl.dart';
import 'package:fruits_hub/core/managers/product/product_cubit.dart';
import 'package:fruits_hub/core/utils/app_images.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/app_text_styles.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/custom_scroll_behavior.dart';
import 'package:fruits_hub/features/search/presentation/views/widgets/search_products_bloc_builder.dart';
import 'package:provider/provider.dart';

class SearchProductsViewBody extends StatefulWidget {
  const SearchProductsViewBody({super.key});

  @override
  State<SearchProductsViewBody> createState() => _SearchProductsViewBodyState();
}

class _SearchProductsViewBodyState extends State<SearchProductsViewBody> {
  final TextEditingController _controller = TextEditingController();
  final RecentSearchLocalRepo repo = RecentSearchLocalRepoImpl();
  final ValueNotifier<List<String>> recentSearches = ValueNotifier([]);
  @override
  void initState() {
    _loadSearches();
    super.initState();
  }

  Future<void> _loadSearches() async {
    final loadedSearches = await repo.getRecentSearches();
    recentSearches.value = loadedSearches;
  }

  Future<void> _onSearch(String searchTerm) async {
    await repo.addSearch(searchTerm);
    recentSearches.value = await repo.getRecentSearches();
  }

  @override
  void dispose() {
    _controller.dispose();
    recentSearches.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: ScrollConfiguration(
        behavior: CustomScrollBehavior(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: 16),
                  _buildSearchField(context),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            SearchProductsBlocBuilder(
              recentSearches: recentSearches,
              textEditingController: _controller,
              recentSearchLocalRepo: repo,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: true,
      decoration: InputDecoration(
        hintText: AppStrings.searchHint.tr(),
        suffixIcon: _buildIcon(Assets.imagesFilter, context),
        prefixIcon: _buildIcon(Assets.imagesSearchIcon, context),
        hintStyle: AppTextStyle.textStyle13w400.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
        border: _buildBorder(context),
        enabledBorder: _buildBorder(context),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onSubmitted: (value) async {
        context.read<ProductCubit>().getSearchedProducts(search: value);
        if (value.trim().isNotEmpty) {
          await _onSearch(value);
        }
      },
    );
  }

  Widget _buildIcon(String asset, BuildContext context) {
    return SizedBox(
      width: 20,
      child: Center(
        child: SvgPicture.asset(
          asset,
          color: Theme.of(context).colorScheme.primary,
          width: 18,
          height: 18,
        ),
      ),
    );
  }

  OutlineInputBorder _buildBorder(BuildContext context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: Theme.of(context).dividerColor, width: 1),
    );
  }
}
