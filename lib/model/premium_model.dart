class PremiumModel {
  int id;
  String duration;
  String price;

  PremiumModel({
    required this.duration,
    required this.price,
    required this.id,
  });

  factory PremiumModel.fromJson(Map<String, dynamic> json) {
    
    return PremiumModel(
      duration: json['duration'],
      price: json['price'].toString(),
      id: json['id'],
    );
  }
}
