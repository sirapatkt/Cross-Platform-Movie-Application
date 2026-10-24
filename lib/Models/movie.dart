class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath; 
  final String backdropPath; 
  final double voteAverage;
  final String releaseDate;
  final List<int> genreIds;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.genreIds,
  });

  // Factory Constructor: ทำหน้าที่แปลง JSON ให้เป็น Object (Data Parsing)
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown Title',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}'
          : 'https://via.placeholder.com/200x300?text=No+Image',
      backdropPath: json['backdrop_path'] != null
          ? 'https://image.tmdb.org/t/p/original${json['backdrop_path']}'
          : 'https://via.placeholder.com/500x300?text=No+Image',
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: json['release_date'] ?? 'Unknown Date',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
    );
  }
}