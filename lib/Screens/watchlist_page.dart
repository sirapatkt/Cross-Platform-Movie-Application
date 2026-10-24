import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/movie.dart';
import 'details_movie.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});
  @override
  WatchlistPageState createState() => WatchlistPageState();
}

class WatchlistPageState extends State<WatchlistPage> {
  List<Movie> favoriteMovies = [];

  @override
  void initState() {
    super.initState();
    _loadWatchlist();
  }

  Future<void> _loadWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    List<String> watchlistJson = prefs.getStringList('my_watchlist') ?? [];
    debugPrint("Loaded ${watchlistJson.length} items from local storage");
    List<Movie> loadedMovies = [];

    for (var item in watchlistJson) {
      try {
        loadedMovies.add(Movie.fromJson(jsonDecode(item)));
      } catch (e) {
        debugPrint("Error: $e");
      }
    }
    setState(() {
      favoriteMovies = loadedMovies;
    });
  }

  Future<void> _deleteMovie(int index) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> watchlistJson = prefs.getStringList('my_watchlist') ?? [];
    watchlistJson.removeAt(index);
    await prefs.setStringList('my_watchlist', watchlistJson);
    
    _loadWatchlist();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Removed from Watchlist'),
        duration: Duration(seconds: 1)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("My Watchlist",
            style: GoogleFonts.kanit(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: _loadWatchlist)
        ],
      ),
      body: favoriteMovies.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border,
                      size: 80, color: Colors.grey[800]),
                  const SizedBox(height: 16),
                  Text("ไม่มีรายการโปรด",
                      style: GoogleFonts.kanit(
                          color: Colors.white60, fontSize: 18)),
                ],
              ),
            )
          : ListView.builder(
              itemCount: favoriteMovies.length,
              itemBuilder: (context, index) {
                final movie = favoriteMovies[index];
                return Dismissible(
                  key: Key(movie.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.redAccent,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _deleteMovie(index);
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        movie.posterPath,
                        width: 60,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => const Icon(
                            Icons.movie,
                            color: Colors.white,
                            size: 50),
                      ),
                    ),
                    title: Text(movie.title,
                        style: GoogleFonts.kanit(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(movie.voteAverage.toString(),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white24, size: 16),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetails(movie: movie)));
                    },
                  ),
                );
              },
            ),
    );
  }
}