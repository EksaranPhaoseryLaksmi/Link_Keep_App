import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../service/api_service.dart';
import '../service/auth_service.dart';
import '../models/Category.dart';
import 'edit_content_screen.dart';

class MyContentsScreen extends StatefulWidget {
  final int? categoryId; // optional category filter

  const MyContentsScreen({super.key, this.categoryId});

  @override
  State<MyContentsScreen> createState() => _MyContentsScreenState();
}

class _MyContentsScreenState extends State<MyContentsScreen> {
  List<Map<String, dynamic>> _contents = [];
  List<Map<String, dynamic>> _filteredContents = [];
  List<Category> _categories = [];
  int? _selectedCategoryId;
  final TextEditingController _searchController = TextEditingController();
  bool _loading = true;
  String? _token;
  bool _showFavouritesOnly = false;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.categoryId; // set initial category filter
    _initTokenAndData();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _initTokenAndData() async {
    final token = await AuthService().getToken();
    if (token == null) return;
    _token = token;
    _fetchCategoriesAndContents();
  }

  Future<void> _fetchCategoriesAndContents() async {
    if (_token == null) return;
    try {
      final apiService = ApiService(_token!);
      final categories = await apiService.fetchCategories();
      final contents = await apiService.getLinks();

      // Ensure is_favorite is boolean
      for (var item in contents) {
        item['is_favorite'] = item['is_favorite'].toString() == '1' ||
            item['is_favorite'].toString().toLowerCase() == 'true';
      }

      setState(() {
        _categories = categories;
        _contents = contents;
        _filteredContents = contents;
        _loading = false;
      });

      _filterContents();
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _onSearchChanged() => _filterContents();

  void _filterContents() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContents = _contents.where((item) {
        final title = item['title']?.toString().toLowerCase() ?? '';
        final matchesTitle = title.contains(query);

        final matchesCategory = _selectedCategoryId == null ||
            item['category_id'].toString() == _selectedCategoryId.toString();

        final isFavorite = item['is_favorite'] == true;
        final matchesFavourite = !_showFavouritesOnly || isFavorite;

        return matchesTitle && matchesCategory && matchesFavourite;
      }).toList();
    });
  }

  void _onCategorySelected(int? categoryId) {
    setState(() => _selectedCategoryId = categoryId);
    _filterContents();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        elevation: 0,
        title: const Text(
          "My Content",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by title',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text(
                  "Show Favourites Only",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: _showFavouritesOnly,
                  onChanged: (value) {
                    setState(() {
                      _showFavouritesOnly = value;
                    });
                    _filterContents();
                  },
                  activeColor: Colors.red,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: () => _onCategorySelected(null),
                    child: _buildCategoryCard(
                        'All',
                        'https://cdn-icons-png.flaticon.com/512/6791/6791242.png',
                        null,
                        _selectedCategoryId == null),
                  );
                }

                final cat = _categories[index - 1];
                return GestureDetector(
                  onTap: () => _onCategorySelected(cat.id),
                  child: _buildCategoryCard(
                      cat.name, cat.imageUrl ?? '', cat.id, _selectedCategoryId == cat.id),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _filteredContents.isEmpty
                ? const Center(child: Text("No content found"))
                : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredContents.length,
              separatorBuilder: (_, __) =>
                  Container(height: 6, color: Colors.teal[200]),
              itemBuilder: (context, index) {
                final item = _filteredContents[index];
                return _buildContentCard(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
      String name, String? imageUrl, int? id, bool selected) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: selected ? Border.all(color: Colors.teal, width: 2) : null,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(2, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageUrl != null && imageUrl.isNotEmpty)
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(Icons.category, color: Colors.white),
            ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selected ? Colors.teal : Colors.black,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContentCard(Map<String, dynamic> item) {
    bool isFavourite = item['is_favorite'] == true;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              final Uri url = Uri.parse(item['url']!);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Could not open link")));
              }
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.teal[400],
                  borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.upload, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title: ${item['title']}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () async {
                    final Uri url = Uri.parse(item['url']!);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Text(
                    item['describtion'] ?? '',
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                color: Colors.blue,
                onPressed: () {
                  if (_token == null) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          EditContentScreen(contentItem: item, token: _token!),
                    ),
                  ).then((updated) {
                    if (updated == true) _fetchCategoriesAndContents();
                  });
                },
              ),
              IconButton(
                icon: Icon(
                    item['is_favorite'] == true ? Icons.favorite : Icons.favorite_border),
                color: item['is_favorite'] == true ? Colors.red : Colors.black54,
                onPressed: () async {
                  if (_token == null) return;

                  final oldValue = item['is_favorite'] == true;

                  setState(() {
                    item['is_favorite'] = !oldValue;
                  });

                  try {
                    final apiService = ApiService(_token!);
                    await apiService.updateLink(item['id'].toString(), {
                      ...item,
                      'is_favorite': item['is_favorite']! ? "1" : "0",
                    });
                  } catch (e) {
                    setState(() {
                      item['is_favorite'] = oldValue;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to update favourite: $e')));

                  }

                  _filterContents();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
