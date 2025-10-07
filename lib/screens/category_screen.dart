import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'name': 'Food', 'icon': Icons.restaurant_menu, 'color': Colors.orange},
      {'name': 'Trip.', 'icon': Icons.flight_takeoff, 'color': Colors.blue},
      {'name': 'Fashion', 'icon': Icons.checkroom, 'color': Colors.pink},
      {'name': 'Accessories', 'icon': Icons.watch, 'color': Colors.black87},
      {'name': 'Music', 'icon': Icons.music_note, 'color': Colors.redAccent},
      {'name': 'Cosmetics', 'icon': Icons.face, 'color': Colors.purple},
      {'name': 'Gaming', 'icon': Icons.sports_esports, 'color': Colors.blueAccent},
      {'name': 'Things', 'icon': Icons.category, 'color': Colors.teal},
      {'name': 'Music', 'icon': Icons.music_note, 'color': Colors.redAccent},
      {'name': 'Cosmetics', 'icon': Icons.face, 'color': Colors.purple},
      {'name': 'Gaming', 'icon': Icons.sports_esports, 'color': Colors.blueAccent},
      {'name': 'Things', 'icon': Icons.category, 'color': Colors.teal},
    ];

    return Scaffold(
      backgroundColor: Colors.greenAccent, // teal frame background
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text(
          'Category',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        //centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // ---------------- Main Content ----------------
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9, // not full width
          height: MediaQuery.of(context).size.height * 0.8, // not full height
          decoration: BoxDecoration(
            color: Colors.grey[200], // light gray background for grid
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 4 columns
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return InkWell(
                onTap: () {
                  Navigator.pop(context, cat['name']); // Return selected name
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(cat['icon'], color: cat['color'], size: 32),
                      const SizedBox(height: 8),
                      Text(
                        cat['name'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
