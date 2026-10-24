import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Models/movie.dart';
import '../Services/api_service.dart';
import 'details_movie.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  List<Movie> movies = [];
  bool isSearching = false;

  void _search(String query) async {
    if (query.isEmpty) {
      setState(() {
        movies = [];
        isSearching = false;
      });
      return;
    }

    setState(() => isSearching = true);
    try {
      var result = await ApiService.searchMovies(query);
      setState(() {
        movies = result;
        isSearching = false;
      });
    } catch (e) {
      setState(() => isSearching = false);
      debugPrint("Error searching movies: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            style: GoogleFonts.kanit(color: Colors.white),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              hintText: "Search Movies...",
              hintStyle: GoogleFonts.kanit(color: Colors.grey[600]),
              border: InputBorder.none,
              suffixIcon: isSearching
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: CircularProgressIndicator(
                          color: Colors.redAccent,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : const Icon(Icons.search, color: Colors.redAccent),
            ),
            onChanged: _search,
          ),
        ),
      ),
      body: movies.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.movie_creation_outlined,
                      size: 80, color: Colors.grey[850]),
                  const SizedBox(height: 15),
                  Text(
                    "Find your next favorite movie",
                    style: GoogleFonts.kanit(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MovieDetails(movie: movie),
                      ),
                    );
                  },
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: movie.posterPath,
                      width: 50,
                      height: 75,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: Colors.grey[900]),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                  title: Text(
                    movie.title,
                    style: GoogleFonts.kanit(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 5),
                      Text(
                        movie.voteAverage.toString(),
                        style: GoogleFonts.kanit(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}