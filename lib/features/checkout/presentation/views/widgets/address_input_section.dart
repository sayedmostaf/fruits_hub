// address_input_section.dart
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
      physics: const BouncingScrollPhysics(),
      child: ValueListenableBuilder<AutovalidateMode>(
        valueListenable: valueListenable,
        builder:
            (context, value, child) => Form(
              key: formKey,
              autovalidateMode: value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    AppStrings.shippingDetails.tr(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    onSaved: (value) {
                      context
                          .read<OrderEntity>()
                          .shippingAddressEntity
                          .fullName = value?.trim() ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.fullNameRequired.tr();
                      }
                      return null;
                    },
                    hintText: AppStrings.fullName.tr(),
                    textInputType: TextInputType.name,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    onSaved: (value) {
                      context.read<OrderEntity>().shippingAddressEntity.email =
                          value?.trim() ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.emailRequired.tr();
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return AppStrings.validEmailRequired.tr();
                      }
                      return null;
                    },
                    hintText: AppStrings.email.tr(),
                    textInputType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    onSaved: (value) {
                      context
                          .read<OrderEntity>()
                          .shippingAddressEntity
                          .address = value?.trim() ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.addressRequired.tr();
                      }
                      return null;
                    },
                    hintText: AppStrings.address.tr(),
                    textInputType: TextInputType.streetAddress,
                    prefixIcon: const Icon(Icons.location_on_outlined),
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    onSaved: (value) {
                      context.read<OrderEntity>().shippingAddressEntity.city =
                          value?.trim() ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.cityRequired.tr();
                      }
                      return null;
                    },
                    hintText: AppStrings.city.tr(),
                    textInputType: TextInputType.text,
                    prefixIcon: const Icon(Icons.location_city_outlined),
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    onSaved: (value) {
                      context.read<OrderEntity>().shippingAddressEntity.phone =
                          value?.trim() ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.phoneRequired.tr();
                      }
                      if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
                        return AppStrings.validPhoneRequired.tr();
                      }
                      return null;
                    },
                    hintText: AppStrings.phoneNumber.tr(),
                    textInputType: TextInputType.phone,
                    prefixIcon: const Icon(Icons.phone_outlined),
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    onSaved: (value) {
                      context
                          .read<OrderEntity>()
                          .shippingAddressEntity
                          .houseNumber = value?.trim() ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.houseNumberRequired.tr();
                      }
                      return null;
                    },
                    hintText: AppStrings.houseNumber.tr(),
                    textInputType: TextInputType.text,
                    prefixIcon: const Icon(Icons.numbers_outlined),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
      ),
    );
  }
}
