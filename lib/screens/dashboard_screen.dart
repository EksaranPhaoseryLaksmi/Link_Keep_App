import 'package:flutter/material.dart';
import 'add_content_screen.dart';
import 'my_contents_screen.dart';
import 'category_screen.dart'; // ✅ Import the Category screen

class DashboardScreen extends StatefulWidget {
  final String token;
  const DashboardScreen({required this.token, super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();

  // 🔹 Sample categories
  final List<Map<String, String>> categories = [
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/2991/2991148.png',
      'name': 'Technology'
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/616/616408.png',
      'name': 'Education'
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/869/869636.png',
      'name': 'Sports'
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/2972/2972118.png',
      'name': 'Travel'
    },
    {
      'image': 'https://cdn-icons-png.flaticon.com/512/744/744922.png',
      'name': 'Health'
    },
  ];

  // 🔹 Custom rounded button (not full width)
  Widget _buildRoundedButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    double paddingH = 20,
    double paddingV = 12,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color, width: 1.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV),
      ),
      icon: Icon(icon, color: color, size: 22),
      label: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color,
          fontSize: 16,
        ),
      ),
    );
  }

  // 🔹 Categories section
  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ "Categories" Button (Arrow icon at end)
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

        // 🔹 Horizontal Scrollable Category Boxes
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return Container(
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
                    Image.network(cat['image']!, width: 50, height: 50),
                    const SizedBox(height: 6),
                    Text(
                      cat['name']!,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Section 1: Search box
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search here',
                filled: true,
                fillColor: Colors.grey[200],
                suffixIcon: const Icon(Icons.search, color: Colors.blue),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                  const BorderSide(color: Colors.blue, width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 Section 2: Categories
            _buildCategoriesSection(),

            const SizedBox(height: 30),

            // 🔹 Add More Contents Button
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddContentScreen(),
                    ),
                  );
                },
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child:
                  const Icon(Icons.add, color: Colors.black, size: 18),
                ),
                label: const Text(
                  "Add more contents",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  elevation: 0,
                  minimumSize: const Size(10, 40),
                ),
              ),
            ),

            const SizedBox(height: 80),

            // 🔹 My Contents Button
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyContentsScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 20),
                    elevation: 0,
                    minimumSize: const Size(180, 45),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "My Contents",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(width: 80),
                      Icon(Icons.arrow_forward_ios,
                          size: 18, color: Colors.black),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
