class DetailsModel {
  String shop;
  String phone;
  String email;
  String logo;

  DetailsModel(
      {required this.shop,
      required this.phone,
      required this.email,
      required this.logo});

  factory DetailsModel.fromJson(Map<String, dynamic> json) {
    return DetailsModel(
      shop: json['shop'],
      phone: json['phone'].toString(),
      email: json['email'],
      logo: json['logo'],
    );
  }
}
