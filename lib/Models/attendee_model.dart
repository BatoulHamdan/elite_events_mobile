class Attendee {
  final String id;
  final String fullName;
  final String email;
  final String event;

  Attendee({
    required this.id,
    required this.fullName,
    required this.email,
    required this.event,
  });

  factory Attendee.fromJson(Map<String, dynamic> json) {
    return Attendee(
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      event: json['event'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'fullName': fullName, 'email': email, 'event': event};
  }
}
