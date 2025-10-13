import 'package:flutter/material.dart';
import '../service/api_service.dart';
import '../service/auth_service.dart';
import '../models/Category.dart';

class AddContentScreen extends StatefulWidget {
  const AddContentScreen({super.key});

  @override
  State<AddContentScreen> createState() => _AddContentScreenState();
}

class _AddContentScreenState extends State<AddContentScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  List<Category> _categories = [];
  Category? _selectedCategory;
  bool _loadingCategories = true;
  bool _saving = false;

  int? _selectedStatus; // 0 = Video, 1 = Music, 2 = WebView

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final authService = AuthService();
    final token = await authService.getToken();
    if (token == null) return;

    final apiService = ApiService(token);
    try {
      final categories = await apiService.fetchCategories();
      setState(() {
        _categories = categories;
        _loadingCategories = false;
      });
    } catch (e) {
      setState(() {
        _loadingCategories = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error loading categories: $e')));
    }
  }

  Future<void> _saveContent() async {
    if (_titleController.text.isEmpty ||
        _linkController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => _saving = true);

    final authService = AuthService();
    final token = await authService.getToken();
    if (token == null) return;

    final apiService = ApiService(token);

    final data = {
      "url": _linkController.text,
      "title": _titleController.text,
      "description": _notesController.text,
      "created_by": "1", // Replace with current user ID if available
      "category_id": _selectedCategory!.id.toString(),
      "status": _selectedStatus.toString(), // Add status here
    };

    try {
      await apiService.createLink(data);
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Content saved!')));
      Navigator.pop(context);
    } catch (e) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error saving content: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        elevation: 0,
        title: const Text(
          "Add More Content",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: _loadingCategories
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Content Title',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Link
              TextField(
                controller: _linkController,
                decoration: InputDecoration(
                  hintText: 'Link URL',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonFormField<Category>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    hintText: 'Category',
                    border: InputBorder.none,
                  ),
                  items: _categories
                      .map((cat) => DropdownMenuItem<Category>(
                    value: cat,
                    child: Text(cat.name),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Status Dropdown
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonFormField<int>(
                  value: _selectedStatus,
                  decoration: const InputDecoration(
                    hintText: 'Content Type (Status)',
                    border: InputBorder.none,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 0,
                      child: Text('Video'),
                    ),
                    DropdownMenuItem(
                      value: 1,
                      child: Text('Music'),
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text('WebView'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Notes
              TextField(
                controller: _notesController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Notes (optional)',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _saving ? null : _saveContent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 14),
                  ),
                  child: _saving
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    'Save',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
