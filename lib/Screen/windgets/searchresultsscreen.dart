import 'package:flutter/material.dart';

class SearchResultsScreen extends StatelessWidget {
  final String searchTerm;

  SearchResultsScreen({required this.searchTerm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 60,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new),
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Center(
            child: Text(
              'No se encontraron resultados para: $searchTerm',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
