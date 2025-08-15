class PaymentModel {
  final String id;
  final String card;
  final String name;
  final double amount;
  final String status;
  final String expire;
  final String cvv;
  final DateTime date;

  PaymentModel({
    required this.id,
    required this.card,
    required this.name,
    required this.amount,
    required this.status,
    required this.expire,
    required this.cvv,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'card': card,
      'name': name,
      'amount': amount,
      'status': status,
      'expire': expire,
      'cvv': cvv,
      'date': date.toIso8601String(),  
    };
  }

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] ?? '',
      card: json['card'] ?? '',
      name: json['name'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'Pending',
      expire: json['expire'] ?? '',
      cvv: json['cvv'] ?? '',
      date: DateTime.parse(
        json['date'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
