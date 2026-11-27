class ItineraryModel {
  final String id;
  final String tripId;
  final int dayNumber;
  final String timeSlot;
  final String title;
  final String location;
  final String description;

  const ItineraryModel({
    required this.id,
    required this.tripId,
    required this.dayNumber,
    required this.timeSlot,
    required this.title,
    this.location = '',
    this.description = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'tripId': tripId,
        'dayNumber': dayNumber,
        'timeSlot': timeSlot,
        'title': title,
        'location': location,
        'description': description,
      };

  factory ItineraryModel.fromJson(Map<String, dynamic> json, {String? docId}) {
    return ItineraryModel(
      id: (json['id'] as String?) ?? docId ?? '',
      tripId: (json['tripId'] as String?) ?? '',
      dayNumber: json['dayNumber'] is num
          ? (json['dayNumber'] as num).toInt()
          : int.tryParse(json['dayNumber']?.toString() ?? '') ?? 1,
      timeSlot: (json['timeSlot'] as String?) ?? '08:00 - 10:00',
      title: (json['title'] as String?) ?? '',
      location: (json['location'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
    );
  }
}