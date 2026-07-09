class Movie {
  final int id;
  final String title;
  final String posterPath;
  final double rating;
  final String overview;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.rating,
    required this.overview,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? 'Unknown',
      posterPath: json['poster_path'] ?? '',
      rating: (json['vote_average'] ?? 0).toDouble(),
      overview: json['overview'] ?? '',
    );
  }

  String get posterUrl => posterPath.isNotEmpty
      ? 'https://image.tmdb.org/t/p/w500$posterPath'
      : '';
}
