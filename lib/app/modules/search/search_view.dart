import 'package:flutter/material.dart';

class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search'), centerTitle: true),
      body: Center(
        child: Text(
          'Search Page',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
