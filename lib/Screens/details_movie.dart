import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../Models/movie.dart';
import '../Services/api_service.dart';

class MovieDetails extends StatefulWidget {
  final Movie movie;
  const MovieDetails({super.key, required this.movie});
  @override
  MovieDetailsState createState() => MovieDetailsState();
}

class MovieDetailsState extends State<MovieDetails> {
  bool isFavorite = false;
  late Future<String?> _trailerFuture;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
    _trailerFuture = ApiService.getTrailerKey(widget.movie.id);
  }

  Future<void> _checkFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> watchlist = prefs.getStringList('my_watchlist') ?? [];
    if (mounted) {
      setState(() {
        isFavorite = watchlist.any(
            (item) => jsonDecode(item)['id'] == widget.movie.id);
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> watchlist = prefs.getStringList('my_watchlist') ?? [];

    if (isFavorite) {
      watchlist.removeWhere(
          (item) => jsonDecode(item)['id'] == widget.movie.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Removed from Watchlist'),
            duration: Duration(seconds: 1)));
      }
    } else {
      String posterFile = widget.movie.posterPath;
      if (posterFile.contains('/')) {
        posterFile = '/${posterFile.split('/').last}';
      }
      String backdropFile = widget.movie.backdropPath;
      if (backdropFile.contains('/')) {
        backdropFile = '/${backdropFile.split('/').last}';
      }
      Map<String, dynamic> movieData = {
        'id': widget.movie.id,
        'title': widget.movie.title,
        'overview': widget.movie.overview,
        'poster_path': posterFile,
        'backdrop_path': backdropFile,
        'vote_average': widget.movie.voteAverage,
        'release_date': widget.movie.releaseDate,
        'genre_ids': widget.movie.genreIds,
      };
      watchlist.add(jsonEncode(movieData));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Added to Watchlist!'),
            duration: Duration(seconds: 1)));
      }
    }
    await prefs.setStringList('my_watchlist', watchlist);
    if (mounted) {
      setState(() {
        isFavorite = !isFavorite;
      });
    }
  }

  Widget _buildGenreChip(String label) {
    return Chip(
      label: Text(label,
          style: GoogleFonts.kanit(color: Colors.white, fontSize: 12)),
      backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
      side: const BorderSide(color: Colors.redAccent, width: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<int, String> genreMap = {
      28: "Action", 12: "Adventure", 16: "Animation", 35: "Comedy",
      80: "Crime", 99: "Documentary", 18: "Drama", 10751: "Family",
      14: "Fantasy", 36: "History", 27: "Horror", 10402: "Music",
      9648: "Mystery", 10749: "Romance", 878: "Sci-Fi", 10770: "TV Movie",
      53: "Thriller", 10752: "War", 37: "Western"
    };

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: _toggleFavorite,
        child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.movie.backdropPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) =>
                    Container(color: Colors.grey[900]),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.movie.title,
                      style: GoogleFonts.kanit(
                          fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(widget.movie.releaseDate,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.grey)),
                      const SizedBox(width: 20),
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 5),
                      Text(widget.movie.voteAverage.toString(),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: widget.movie.genreIds
                        .map((id) =>
                            _buildGenreChip(genreMap[id] ?? "Movie"))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  Text("เรื่องย่อ : ",
                      style: GoogleFonts.kanit(
                          fontSize: 22, color: Colors.redAccent)),
                  const SizedBox(height: 8),
                  Text(widget.movie.overview,
                      style: GoogleFonts.lato(fontSize: 16, height: 1.5)),
                  const SizedBox(height: 30),
                  FutureBuilder<String?>(
                    future: _trailerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: SpinKitWave(
                                color: Colors.redAccent, size: 30));
                      }
                      if (snapshot.hasData && snapshot.data != null) {
                        final controller =
                            YoutubePlayerController.fromVideoId(
                          videoId: snapshot.data.toString(),
                          params: const YoutubePlayerParams(
                              showFullscreenButton: true),
                        );
                        return Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: YoutubePlayer(controller: controller),
                              ),
                            ),
                          ),
                        );
                      }
                      return const Center(
                          child: Text("No Trailer Available"));
                    },
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}