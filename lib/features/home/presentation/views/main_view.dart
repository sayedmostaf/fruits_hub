import 'package:flutter/material.dart';
import 'package:fruits_hub/features/home/presentation/views/cart_view.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/custom_bottom_navigation_bar.dart';
import 'package:fruits_hub/features/home/presentation/views/widgets/home_view.dart';

import 'products_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});
  static const routeName = 'home_view';

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentViewIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        onItemTapped: (index) {
          currentViewIndex = index;
          setState(() {});
        },
      ),
      body: SafeArea(
        child: IndexedStack(
          index: currentViewIndex,
          children: [HomeView(), ProductsView(), CartView()],
        ),
      ),
    );
  }
}
