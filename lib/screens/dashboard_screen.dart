import 'package:flutter/material.dart';
import 'add_content_screen.dart';
import 'my_contents_screen.dart';
import 'category_screen.dart';
import '../service/api_service.dart';
import '../service/auth_service.dart';
import '../models/Category.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<Category>>? _futureCategories;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final authService = AuthService();
    final token = await authService.getToken();
    if (token == null) return;
    _token = token;

    final apiService = ApiService(token);
    setState(() {
      _futureCategories = apiService.fetchCategories();
    });
  }

  // Fallback icons
  String getFallbackIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('food')) {
      return 'https://cdn-icons-png.flaticon.com/512/737/737967.png';
    } else if (lower.contains('restaurant')) {
      return 'https://cdn-icons-png.flaticon.com/512/948/948036.png';
    } else if (lower.contains('resort')) {
      return 'https://cdn-icons-png.flaticon.com/512/4490/4490936.png';
    } else {
      return 'https://cdn-icons-png.flaticon.com/512/609/609803.png';
    }
  }

  Widget _buildCategoriesSection() {
    return FutureBuilder<List<Category>>(
      future: _futureCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            height: 200,
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(child: Text('No categories found')),
          );
        }

        final categories = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.teal, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                ),
                onPressed: () async {
                  final selectedCategory = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CategoryScreen()),
                  );
                  if (selectedCategory != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Selected: $selectedCategory"),
                        backgroundColor: Colors.teal,
                      ),
                    );
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "Categories",
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios, color: Colors.teal, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final imageUrl = cat.imageUrl.isNotEmpty
                      ? cat.imageUrl
                      : getFallbackIcon(cat.name);

                  return GestureDetector(
                    onTap: () {
                      if (_token == null) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MyContentsScreen(categoryId: cat.id),
                        ),
                      );
                    },
                    child: Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[100],
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 5,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cat.name,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddContentButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddContentScreen()),
          );
        },
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.black, size: 18),
        ),
        label: const Text(
          "Add more contents",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          elevation: 0,
          minimumSize: const Size(10, 40),
        ),
      ),
    );
  }

  Widget _buildMyContentsButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyContentsScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[400],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            elevation: 0,
            minimumSize: const Size(180, 45),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "My Contents",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
              ),
              SizedBox(width: 80),
              Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/Keep-Logo.png'),
              backgroundColor: Colors.white,
            ),
            const SizedBox(width: 8),
            const Text(
              "Link Keep",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search box
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search here',
                filled: true,
                fillColor: Colors.grey[200],
                suffixIcon: const Icon(Icons.search, color: Colors.blue),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildCategoriesSection(),
            const SizedBox(height: 30),
            _buildAddContentButton(),
            const SizedBox(height: 30),
            _buildMyContentsButton(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
