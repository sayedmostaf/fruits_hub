import 'package:fruits_hub/features/checkout/domain/entities/shipping_address_entity.dart';

class ShippingAddressModel extends ShippingAddressEntity {
  ShippingAddressModel({
    super.fullName,
    super.phone,
    super.address,
    super.city,
    super.email,
    super.houseNumber,
  });

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) {
    return ShippingAddressModel(
      fullName: json['fullName'],
      phone: json['phone'],
      address: json['address'],
      city: json['city'],
      email: json['email'],
      houseNumber: json['houseNumber'],
    );
  }

  factory ShippingAddressModel.fromEntity(ShippingAddressEntity entity) {
    return ShippingAddressModel(
      fullName: entity.fullName,
      phone: entity.phone,
      address: entity.address,
      city: entity.city,
      email: entity.email,
      houseNumber: entity.houseNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'city': city,
      'email': email,
      'houseNumber': houseNumber,
    };
  }
}
