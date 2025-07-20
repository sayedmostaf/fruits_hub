class ShippingAddressEntity {
  String? fullName, phone, address, city, email, houseNumber;
  ShippingAddressEntity({
    this.fullName,
    this.phone,
    this.address,
    this.city,
    this.email,
    this.houseNumber,
  });

  @override
  String toString() {
    return '$city, $address, $houseNumber';
  }
}
