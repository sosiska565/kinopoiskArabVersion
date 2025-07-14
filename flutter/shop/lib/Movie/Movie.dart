class Movie {
  final int id;
  final String name;
  final int? year;
  final String? description;
  final double? ratingKp;
  final String? posterUrl;
  bool? isStar;
  final String? userEmail;

  Movie({
    required this.id,
    required this.name,
    this.year,
    this.description,
    this.ratingKp,
    this.posterUrl,
    this.isStar,
    this.userEmail,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    dynamic kpRating;
    if (json['rating'] is Map) {
      kpRating = json['rating']['kp'];
    } else {
      kpRating = json['ratingKp'];
    }

    String? finalPosterUrl;
    if (json['poster'] is Map && json['poster']['url'] != null) {
      finalPosterUrl = json['poster']['url'];
    } 
    else if (json['posterUrl'] != null) {
      finalPosterUrl = json['posterUrl'];
    }

    return Movie(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? 'Без названия',
      year: json['year'],
      description: json['description'],
      ratingKp: (kpRating as num?)?.toDouble(),
      
      posterUrl: finalPosterUrl,
      
      isStar: json['isStar'] ?? json['star'] ?? false,
      userEmail: json['userEmail'],
    );
  }
}