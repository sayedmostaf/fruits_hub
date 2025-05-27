class ShippingAddressEntity {
  String? name;
  String? phone;
  String? address;
  String? city;
  String? email;
  String? floor;

  ShippingAddressEntity({
    this.name,
    this.phone,
    this.address,
    this.city,
    this.email,
    this.floor,
  });
  @override
  String toString() {
    return '$address $floor $city';
  }
}
