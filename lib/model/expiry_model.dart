class ExpiryModel {
  int expiryDate;

  ExpiryModel({required this.expiryDate});

  factory ExpiryModel.fromJson(Map<String, dynamic> json) {
    return ExpiryModel(expiryDate: json['day']);
  }
}
