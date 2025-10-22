import 'package:flutter/material.dart';
import 'package:link_keep_app/service/auth_service.dart';
import '../models/Category.dart';
import '../service/api_service.dart';

class EditCategoryScreen extends StatefulWidget {
  final String token;
  final Category? category;

  const EditCategoryScreen({super.key, required this.token, this.category});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _urlController.text = widget.category!.imageUrl;
      _descController.text = widget.category!.describtion ?? '';
    }
  }

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final int? userid = await AuthService().getUserId();
    final apiService = ApiService(widget.token);
    try {
      if (widget.category == null) {
        // Add new
        await apiService.addCategory({
          'name': _nameController.text,
          'url': _urlController.text,
          'description': _descController.text,
          'created_by': userid,
          'sub': '',
        });
      } else {
        // Update existing
        await apiService.updateCategory({
          'id': widget.category!.id,
          'name': _nameController.text,
          'url': _urlController.text,
          'description': _descController.text,
          'updated_by': '1',
          'sub': '',
          'is_active': '1',
        });
      }
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save category: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.category != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text(isEdit ? 'Edit Category' : 'Add Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Category Name'),
                validator: (value) =>
                value!.isEmpty ? 'Please enter category name' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _urlController,
                decoration:
                const InputDecoration(labelText: 'Category Image URL'),
                validator: (value) =>
                value!.isEmpty ? 'Please enter image URL' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                decoration:
                const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _saveCategory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(isEdit ? 'Update Category' : 'Add Category'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
