import 'dart:io';

class CollectionItem {
  final String title;
  final String description;
  final List<File> images;

  CollectionItem({
    required this.title,
    required this.description,
    required List<String> imagePaths,
  }) : images = imagePaths.map((path) => File(path)).toList();

  bool get hasValidImages =>
      images.length <= 3 && images.every((image) => image.existsSync());
}
