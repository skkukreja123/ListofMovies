class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final double voteAverage;
  final int voteCount;
  final List<int> genreIds;
  final bool adult;
  final String originalLanguage;
  final String originalTitle;
  final bool video;
  final double popularity;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.genreIds,
    required this.adult,
    required this.originalLanguage,
    required this.originalTitle,
    required this.video,
    required this.popularity,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      voteAverage: (json['vote_average'] as num).toDouble(),
      voteCount: json['vote_count'],
      genreIds: List<int>.from(json['genre_ids']),
      adult: json['adult'],
      originalLanguage: json['original_language'],
      originalTitle: json['original_title'],
      video: json['video'],
      popularity: (json['popularity'] as num).toDouble(),
    );
  }

  static Movie empty() {
    return Movie(
      id: 0,
      title: '',
      overview: '',
      posterPath: '',
      backdropPath: '',
      releaseDate: '',
      voteAverage: 0.0,
      voteCount: 0,
      genreIds: [],
      adult: false,
      originalLanguage: '',
      originalTitle: '',
      video: false,
      popularity: 0.0,
    );
  }
}
