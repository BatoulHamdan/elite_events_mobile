class Review {
  final String id;
  final String userId;
  final String comment;

  Review({required this.id, required this.userId, required this.comment});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'],
      userId: json["userId"]["_id"],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'userId': userId, 'comment': comment};
  }
}
