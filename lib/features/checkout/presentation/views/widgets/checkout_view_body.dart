import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:fruits_hub/core/functions/build_error_snack_bar.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/widgets/custom_button.dart';
import 'package:fruits_hub/features/checkout/data/models/paypal_payment_model.dart';
import 'package:fruits_hub/features/checkout/domain/entities/order_entity.dart';
import 'package:fruits_hub/features/checkout/presentation/manager/order/order_cubit.dart';
import 'package:fruits_hub/features/checkout/presentation/views/widgets/checkout_steps.dart';
import 'package:fruits_hub/features/checkout/presentation/views/widgets/checkout_steps_page_view.dart';
import 'package:provider/provider.dart';

class CheckoutViewBody extends StatefulWidget {
  const CheckoutViewBody({super.key, required this.pageIndexNotifier});
  final ValueNotifier<int> pageIndexNotifier;
  @override
  State<CheckoutViewBody> createState() => _CheckoutViewBodyState();
}

class _CheckoutViewBodyState extends State<CheckoutViewBody> {
  late final PageController pageController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ValueNotifier<AutovalidateMode> valueListenable =
      ValueNotifier<AutovalidateMode>(AutovalidateMode.disabled);
  @override
  void initState() {
    super.initState();
    pageController = PageController();
    pageController.addListener(() {
      final page = pageController.page?.round() ?? 0;
      if (widget.pageIndexNotifier.value != page) {
        widget.pageIndexNotifier.value = page;
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<int>(
          valueListenable: widget.pageIndexNotifier,
          builder: (context, currentPage, _) {
            return CheckoutSteps(
              pageController: pageController,
              currentPage: currentPage,
              onTap: (index) {
                if (index == 0) {
                  pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                  );
                } else if (index == 1) {
                  _validatePaymentMethod(context);
                } else {
                  _validateAddressForm(context);
                }
              },
            );
          },
        ),
        SizedBox(height: 8),
        Expanded(
          child: CheckoutStepsPageView(
            formKey: formKey,
            pageController: pageController,
            valueListenable: valueListenable,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: CustomButton(
            onPressed: () {
              final page = widget.pageIndexNotifier.value;
              if (page == 0) {
                _validatePaymentMethod(context);
              } else if (page == 1) {
                _validateAddressForm(context);
              } else {
                _processPayment(context);
              }
            },
            text: getNextButtonText(
              currentPageIndex: widget.pageIndexNotifier.value,
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  void _processPayment(BuildContext context) {
    final order = context.read<OrderEntity>();
    final orderCubit = context.read<OrderCubit>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => PaypalCheckoutView(
              sandboxMode: true,

              onSuccess: (Map params) async {
                orderCubit.addOrder(orderEntity: order);
                order.cart.clearCart();
                Navigator.pop(context);
              },
              onError: (error) {
                log("onError: $error");
                buildErrorSnackBar(
                  context,
                  message: AppStrings.paymentFailed.tr(),
                );
                Navigator.pop(context);
              },
              onCancel:
                  () => buildErrorSnackBar(
                    context,
                    message: AppStrings.paymentCancelled.tr(),
                  ),
              transactions: [
                PaypalPaymentModel.fromEntity(orderEntity: order).toJson(),
              ],
              note: AppStrings.paymentNote.tr(),
              // TODO: add clientId and secretKey for paypal
              clientId: 'clientId',
              secretKey: 'secretKey',
            ),
      ),
    );
  }

  void _validatePaymentMethod(BuildContext context) {
    final order = context.read<OrderEntity>();
    if (order.payWithCash != null) {
      pageController.nextPage(
        duration: Duration(milliseconds: 250),
        curve: Curves.bounceInOut,
      );
    } else {
      buildErrorSnackBar(context, message: AppStrings.choosePaymentMethod.tr());
    }
  }

  void _validateAddressForm(BuildContext context) {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    } else {
      valueListenable.value = AutovalidateMode.always;
      buildErrorSnackBar(
        context,
        message: AppStrings.completeShippingForm.tr(),
      );
    }
  }
}

String getNextButtonText({required int currentPageIndex}) {
  switch (currentPageIndex) {
    case 0:
    case 1:
      return AppStrings.next.tr();
    case 2:
      return AppStrings.payWithPaypal.tr();
    default:
      return AppStrings.next.tr();
  }
}

List<String> getCheckoutStepsText() {
  return [
    AppStrings.shipping.tr(),
    AppStrings.address.tr(),
    AppStrings.payment.tr(),
  ];
}
