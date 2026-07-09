import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'movie.dart';
import 'movie_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> trending;
  late Future<List<Movie>> popular;
  late Future<List<Movie>> topRated;

  @override
  void initState() {
    super.initState();
    trending = MovieService.fetchTrending();
    popular = MovieService.fetchPopular();
    topRated = MovieService.fetchTopRated();
  }

  Widget _buildMovieRow(String title, Future<List<Movie>> future) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            child: FutureBuilder<List<Movie>>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error loading movies",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  );
                }
                final movies = snapshot.data ?? [];
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: movie.posterUrl.isNotEmpty
                            ? Image.network(
                                movie.posterUrl,
                                width: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  width: 120,
                                  color: Colors.grey[800],
                                  child: const Icon(Icons.movie, color: Colors.white),
                                ),
                              )
                            : Container(
                                width: 120,
                                color: Colors.grey[800],
                                child: const Icon(Icons.movie, color: Colors.white),
                              ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("CineFlix", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Welcome, ${user?.email ?? 'User'}",
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            _buildMovieRow("Trending Now", trending),
            _buildMovieRow("Popular", popular),
            _buildMovieRow("Top Rated", topRated),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
