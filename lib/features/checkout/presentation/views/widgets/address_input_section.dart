import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fruits_hub/core/utils/app_strings.dart';
import 'package:fruits_hub/core/utils/widgets/custom_text_form_field.dart';
import 'package:fruits_hub/features/checkout/domain/entities/order_entity.dart';
import 'package:provider/provider.dart';

class AddressInputSection extends StatelessWidget {
  const AddressInputSection({
    super.key,
    required this.formKey,
    required this.valueListenable,
  });
  final GlobalKey<FormState> formKey;
  final ValueListenable<AutovalidateMode> valueListenable;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: ValueListenableBuilder<AutovalidateMode>(
        valueListenable: valueListenable,
        builder:
            (context, value, child) => Form(
              key: formKey,
              autovalidateMode: value,
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  CustomTextFormField(
                    onSaved: (value) {
                      context
                          .read<OrderEntity>()
                          .shippingAddressEntity
                          .fullName = value;
                    },
                    hintText: AppStrings.fullName.tr(),
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    onSaved: (value) {
                      context.read<OrderEntity>().shippingAddressEntity.email =
                          value;
                    },
                    hintText: AppStrings.email.tr(),
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    onSaved: (value) {
                      context
                          .read<OrderEntity>()
                          .shippingAddressEntity
                          .address = value;
                    },
                    hintText: AppStrings.address.tr(),
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    onSaved: (value) {
                      context.read<OrderEntity>().shippingAddressEntity.city =
                          value;
                    },
                    hintText: AppStrings.city.tr(),
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    onSaved: (value) {
                      context.read<OrderEntity>().shippingAddressEntity.phone =
                          value;
                    },
                    hintText: AppStrings.phoneNumber.tr(),
                    textInputType: TextInputType.phone,
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    onSaved: (value) {
                      context
                          .read<OrderEntity>()
                          .shippingAddressEntity
                          .houseNumber = value;
                    },
                    hintText: AppStrings.houseNumber.tr(),
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
      ),
    );
  }
}
