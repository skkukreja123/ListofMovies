class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
    );
  }
}

class ProductionCompany {
  final String name;
  final String? logoPath;

  ProductionCompany({required this.name, this.logoPath});

  factory ProductionCompany.fromJson(Map<String, dynamic> json) {
    return ProductionCompany(
      name: json['name'],
      logoPath: json['logo_path'],
    );
  }
}

class MovieSpecific {
  final int id;
  final String title;
  final String originalTitle;
  final String overview;
  final String releaseDate;
  final String posterPath;
  final bool adult;
  final double popularity;
  final int voteCount;
  final double voteAverage;
  final String originalLanguage;
  final bool video;
  final String status;
  final String tagline;
  final int runtime;
  final int budget;
  final int revenue;
  final String? homepage;
  final List<Genre> genres;
  final List<String> spokenLanguages;
  final List<String> originCountry;
  final List<ProductionCompany> productionCompanies; // ✅ Updated
  final List<String> productionCountries;

  MovieSpecific({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.releaseDate,
    required this.posterPath,
    required this.adult,
    required this.popularity,
    required this.voteCount,
    required this.voteAverage,
    required this.originalLanguage,
    required this.video,
    required this.status,
    required this.tagline,
    required this.runtime,
    required this.budget,
    required this.revenue,
    required this.homepage,
    required this.genres,
    required this.spokenLanguages,
    required this.originCountry,
    required this.productionCompanies, // ✅ Updated
    required this.productionCountries,
  });

  factory MovieSpecific.fromJson(Map<String, dynamic> json) {
    return MovieSpecific(
      id: json['id'],
      title: json['title'],
      originalTitle: json['original_title'],
      overview: json['overview'],
      releaseDate: json['release_date'],
      posterPath: json['poster_path'],
      adult: json['adult'],
      popularity: (json['popularity'] as num).toDouble(),
      voteCount: json['vote_count'],
      voteAverage: (json['vote_average'] as num).toDouble(),
      originalLanguage: json['original_language'],
      video: json['video'],
      status: json['status'],
      tagline: json['tagline'],
      runtime: json['runtime'],
      budget: json['budget'],
      revenue: json['revenue'],
      homepage: json['homepage'],
      genres: (json['genres'] as List).map((g) => Genre.fromJson(g)).toList(),
      spokenLanguages: (json['spoken_languages'] as List)
          .map((e) => e['english_name'] ?? e['name'] ?? 'Unknown')
          .cast<String>()
          .toList(),
      originCountry: (json['origin_country'] as List).cast<String>(),
      productionCompanies: (json['production_companies'] as List) // ✅ Updated
          .map((e) => ProductionCompany.fromJson(e))
          .toList(),
      productionCountries: (json['production_countries'] as List)
          .map((e) => e['name'])
          .cast<String>()
          .toList(),
    );
  }

  static MovieSpecific empty() {
    return MovieSpecific(
      id: 0,
      title: '',
      originalTitle: '',
      overview: '',
      releaseDate: '',
      posterPath: '',
      adult: false,
      popularity: 0.0,
      voteCount: 0,
      voteAverage: 0.0,
      originalLanguage: '',
      video: false,
      status: '',
      tagline: '',
      runtime: 0,
      budget: 0,
      revenue: 0,
      homepage: null,
      genres: [],
      spokenLanguages: [],
      originCountry: [],
      productionCompanies: [], // ✅ Updated
      productionCountries: [],
    );
  }
}
