// models/category.dart
class Category {
  final int id;
  final String name;
  final String describtion;
  final String createdBy;
  final String createdDate;
  final String imageUrl;

  Category({
    required this.id,
    required this.name,
    required this.describtion,
    required this.createdBy,
    required this.createdDate,
    required this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      imageUrl: json['url'],
      describtion: json['describtion'],
      createdBy: json['created_by'].toString(),
      createdDate: json['created_date'] ?? '',
    );
  }
}
