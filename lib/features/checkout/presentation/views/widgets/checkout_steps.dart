import 'package:flutter/widgets.dart';
import 'package:fruits_hub/core/helper_functions/build_error_bar.dart';
import 'package:fruits_hub/features/checkout/domain/entities/order_entity.dart';
import 'package:fruits_hub/features/checkout/presentation/views/widgets/step_item.dart';
import 'package:provider/provider.dart';

class CheckoutSteps extends StatelessWidget {
  const CheckoutSteps({
    super.key,
    required this.currentPageIndex,
    required this.pageController,
  });
  final int currentPageIndex;
  final PageController pageController;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(getSteps().length, (index) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              if (context.read<OrderEntity>().payWithCash != null) {
                pageController.animateToPage(
                  index,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              } else {
                showBar(context, 'يرجي تحديد طريقه الدفع');
              }
            },
            child: StepItem(
              isActive: index <= currentPageIndex,
              index: (index + 1).toString(),
              text: getSteps()[index],
            ),
          ),
        );
      }),
    );
  }
}

List<String> getSteps() {
  return ['الشحن', 'العنوان', 'الدفع'];
}
