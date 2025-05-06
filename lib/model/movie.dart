class Movie {
  final String title; // Movie title
  final String director; // Movie director
  final String releaseDate; // Movie release date
  final String genre; // Movie genre
  final String posterUrl; // URL of the movie poster

  Movie({
    required this.title,
    required this.director,
    required this.releaseDate,
    required this.genre,
    required this.posterUrl,
  });

  // Factory constructor to create a Movie instance from JSON
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] as String,
      director: json['director'] as String,
      releaseDate: json['release_date'] as String,
      genre: json['genre'] as String,
      posterUrl: json['poster_url'] as String,
    );
  }
}
