import 'package:flutter/material.dart';
import '../models/Category.dart';
import '../service/api_service.dart';

class EditContentScreen extends StatefulWidget {
  final Map<String, dynamic> contentItem;
  final String token;

  const EditContentScreen({
    super.key,
    required this.contentItem,
    required this.token,
  });

  @override
  State<EditContentScreen> createState() => _EditContentScreenState();
}

class _EditContentScreenState extends State<EditContentScreen> {
  late TextEditingController _titleController;
  late TextEditingController _linkController;
  late TextEditingController _notesController;

  Category? _selectedCategory;
  bool _saving = false;
  bool _isActive = true;
  bool _isShared = false;
  bool _isFavourite = false;
  List<Category> _categories = [];
  bool _loadingCategories = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.contentItem['title']);
    _linkController = TextEditingController(text: widget.contentItem['url']);
    _notesController =
        TextEditingController(text: widget.contentItem['describtion'] ?? '');
    _isActive = widget.contentItem['is_active'] == "1";
    _isShared = widget.contentItem['shared'] == "1";
    // in initState()
    _isFavourite = widget.contentItem['is_favorite'].toString() == 'true' || widget.contentItem['is_favorite'].toString() == '1';
    _fetchCategories();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _linkController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    try {
      final apiService = ApiService(widget.token);
      final categories = await apiService.fetchCategories();

      setState(() {
        _categories = categories;
        _selectedCategory = categories.firstWhere(
              (cat) =>
          cat.id.toString() == widget.contentItem['category_id'].toString(),
          orElse: () => categories.first,
        );
        _loadingCategories = false;
      });
    } catch (e) {
      setState(() => _loadingCategories = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to load categories: $e')));
    }
  }

  Future<void> _updateContent() async {
    if (_titleController.text.isEmpty ||
        _linkController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final apiService = ApiService(widget.token);

      final data = {
        "id": widget.contentItem['id'].toString(),
        "url": _linkController.text,
        "title": _titleController.text,
        "description": _notesController.text,
        "created_by": widget.contentItem['created_by'].toString(),
        "category_id": _selectedCategory!.id.toString(),
        "status": widget.contentItem['status'] ?? "1",
        "shared": _isShared ? "1" : "0",
        "is_active": _isActive ? "1" : "0",
        "favourite": _isFavourite,
      };

      await apiService.updateLink(widget.contentItem['id'].toString(), data);

      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Content updated successfully!')),
      );
      Navigator.pop(context, true); // return true to refresh list
    } catch (e) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating content: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        elevation: 0,
        title: const Text(
          "Edit Content",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: _loadingCategories
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade200, // light grey background
              borderRadius: BorderRadius.circular(16), // rounded corners
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _linkController,
                  decoration: const InputDecoration(
                    labelText: 'Link URL',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Description / Notes',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<Category>(
                  value: _selectedCategory,
                  items: _categories
                      .map((cat) => DropdownMenuItem(
                    value: cat,
                    child: Text(cat.name),
                  ))
                      .toList(),
                  onChanged: (value) => setState(() => _selectedCategory = value),
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _isActive,
                      onChanged: (val) => setState(() => _isActive = val ?? true),
                    ),
                    const Text("Active"),
                    const SizedBox(width: 20),
                    Checkbox(
                      value: _isShared,
                      onChanged: (val) => setState(() => _isShared = val ?? false),
                    ),
                    const Text("Shared"),
                    const SizedBox(width: 20),
                    Checkbox(
                      value: _isFavourite,
                      onChanged: (val) => setState(() => _isFavourite = val ?? false),
                    ),
                    const Text("Favourite"),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saving ? null : _updateContent,
                    icon: const Icon(Icons.save),
                    label: _saving ? const Text('Saving...') : const Text('Update'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
