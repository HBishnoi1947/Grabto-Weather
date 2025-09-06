import 'package:flutter/material.dart';
import '../managers/favorites_manager.dart';

// Location List Page with Full Theme Support
class LocationListPage extends StatefulWidget {
  final bool isDarkMode;

  LocationListPage({required this.isDarkMode});

  @override
  _LocationListPageState createState() => _LocationListPageState();
}

class _LocationListPageState extends State<LocationListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  List<String> _favorites = [];

  final List<String> _allCities = [
    'Mumbai', 'Delhi', 'Bangalore', 'Hyderabad', 'Chennai', 'Kolkata',
    'Pune', 'Ahmedabad', 'Jaipur', 'Surat', 'Lucknow', 'Kanpur',
    'Nagpur', 'Indore', 'Thane', 'Bhopal', 'Visakhapatnam', 'Patna',
    'Vadodara', 'Ghaziabad', 'Ludhiana', 'Agra', 'Nashik', 'Faridabad',
    'Meerut', 'Rajkot', 'Varanasi', 'Srinagar', 'Aurangabad', 'Dhanbad'
  ];

  @override
  void initState() {
    super.initState();
    _favorites = FavoritesManager.favorites;
    _searchResults = [];
  }

  void _searchCities(String query) {
    setState(() {
      if (query.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = _allCities
            .where((city) => city.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _addToFavorites(String city) async {
    await FavoritesManager.addFavorite(city);
    setState(() {
      _favorites = FavoritesManager.favorites;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$city added to favorites'),
        backgroundColor: widget.isDarkMode ? Colors.grey.shade700 : Colors.green,
      ),
    );
  }

  void _removeFromFavorites(String city) async {
    await FavoritesManager.removeFavorite(city);
    setState(() {
      _favorites = FavoritesManager.favorites;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$city removed from favorites'),
        backgroundColor: widget.isDarkMode ? Colors.grey.shade700 : Colors.red,
      ),
    );
  }

  void _selectCity(String city) {
    Navigator.pop(context, city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        backgroundColor: widget.isDarkMode ? Colors.grey.shade800 : Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: widget.isDarkMode ? Colors.grey.shade900 : Colors.blue.shade50,
            child: TextField(
              controller: _searchController,
              onChanged: _searchCities,
              style: TextStyle(
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Search for a city...',
                hintStyle: TextStyle(
                  color: widget.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: widget.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: widget.isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: widget.isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: widget.isDarkMode ? Colors.blue.shade400 : Colors.blue.shade600,
                  ),
                ),
                filled: true,
                fillColor: widget.isDarkMode ? Colors.grey.shade800 : Colors.white,
              ),
            ),
          ),
          Expanded(
            child: _searchController.text.isNotEmpty
                ? _buildSearchResults()
                : _buildFavorites(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: widget.isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
            ),
            SizedBox(height: 16),
            Text(
              'No cities found',
              style: TextStyle(
                color: widget.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      color: widget.isDarkMode ? Colors.grey.shade900 : Colors.white,
      child: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final city = _searchResults[index];
          final isFavorite = FavoritesManager.isFavorite(city);

          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: widget.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
                  width: 0.5,
                ),
              ),
            ),
            child: ListTile(
              leading: Icon(
                Icons.location_city,
                color: widget.isDarkMode ? Colors.blue.shade400 : Colors.blue.shade600,
              ),
              title: Text(
                city,
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : (widget.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600),
                ),
                onPressed: () {
                  if (isFavorite) {
                    _removeFromFavorites(city);
                  } else {
                    _addToFavorites(city);
                  }
                },
              ),
              onTap: () => _selectCity(city),
              tileColor: widget.isDarkMode ? Colors.grey.shade900 : Colors.white,
              hoverColor: widget.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
            ),
          );
        },
      ),
    );
  }

  Widget _buildFavorites() {
    return Container(
      color: widget.isDarkMode ? Colors.grey.shade900 : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: widget.isDarkMode ? Colors.grey.shade800 : Colors.blue.shade50,
              border: Border(
                bottom: BorderSide(
                  color: widget.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
            child: Text(
              'Favorite Cities',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: widget.isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: _favorites.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 64,
                          color: widget.isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No favorite cities yet',
                          style: TextStyle(
                            color: widget.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Search and add cities to your favorites',
                          style: TextStyle(
                            color: widget.isDarkMode ? Colors.grey.shade500 : Colors.grey.shade500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _favorites.length,
                    itemBuilder: (context, index) {
                      final city = _favorites[index];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: widget.isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.location_city,
                            color: widget.isDarkMode ? Colors.blue.shade400 : Colors.blue.shade600,
                          ),
                          title: Text(
                            city,
                            style: TextStyle(
                              color: widget.isDarkMode ? Colors.white : Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            'Tap to view weather',
                            style: TextStyle(
                              color: widget.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red.shade400,
                            ),
                            onPressed: () => _removeFromFavorites(city),
                          ),
                          onTap: () => _selectCity(city),
                          tileColor: widget.isDarkMode ? Colors.grey.shade900 : Colors.white,
                          hoverColor: widget.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
