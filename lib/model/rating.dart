class Rating {
  final double rate;
  final int count;

  Rating({required this.rate, required this.count});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: (json['rate'] is int)
          ? (json['rate'] as int).toDouble()
          : json['rate'],
      count: (json['count'] is double)
          ? (json['count'] as double).toInt()
          : json['count'],
    );
  }
}
