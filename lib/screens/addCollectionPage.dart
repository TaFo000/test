import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../CollectionItem.dart';
import 'collectionPage.dart';

class AddCollection extends StatefulWidget {
  const AddCollection({super.key});

  @override
  _AddCollectionState createState() => _AddCollectionState();
}

class _AddCollectionState extends State<AddCollection> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _imageFileList = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<CollectionItem> _collectionItems = [];

  void _pickImage() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null && selectedImages.length <= 3) {
      setState(() {
        _imageFileList = selectedImages;
      });
    }
  }

  void _saveCollectionItem() {
    if (_imageFileList != null && _imageFileList!.isNotEmpty) {
      final imagePaths = _imageFileList!.map((xFile) => xFile.path).toList();
      final newItem = CollectionItem(
        title: _titleController.text,
        description: _descriptionController.text,
        imagePaths: imagePaths,
      );
      if (newItem.hasValidImages) {
        setState(() {
          _collectionItems.add(newItem);
          _imageFileList = [];
          _titleController.clear();
          _descriptionController.clear();
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить коллекцию'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 45,
                  child: TextField(
                    style: TextStyle(color: Color(0xFFFF6600)),
                    controller: _titleController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 3)),
                        labelText: 'Заголовок',
                        labelStyle: TextStyle(color: Color(0xFFFF6600))),
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  style: TextStyle(color: Color(0xFFFF6600)),
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 3)),
                      labelText: 'Описание',
                      labelStyle: TextStyle(color: Color(0xFFFF6600))),
                  maxLines: 3,
                ),
                SizedBox(height: 16.0),
                InkWell(
                  onTap: () {
                    _pickImage();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFFF6600), width: 1),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    width: 250,
                    height: 50,
                    child: Center(
                      child: Text(
                        "Выбрать фотографии",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Color(0xFFFF6600), fontSize: 15),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: _imageFileList?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return Image.file(File(_imageFileList![index].path));
                  },
                ),
                SizedBox(height: 16.0),
                InkWell(
                  onTap: () {
                    _saveCollectionItem();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFFF6600), width: 1),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    width: 250,
                    height: 50,
                    child: Center(
                      child: Text(
                        "Сохранить",
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Color(0xFFFF6600), fontSize: 15),
                      ),
                    ),
                  ),
                ),
                ..._collectionItems
                    .map((item) => ListTile(
                          title: Text(
                            item.title,
                            style: TextStyle(color: Color(0xFFFF6600)),
                          ),
                          subtitle: Text(
                            item.description,
                            style: TextStyle(color: Colors.black38),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: item.images
                                .map((img) =>
                                    Image.file(img, width: 50, height: 50))
                                .toList(),
                          ),
                        ))
                    .toList(),
                SizedBox(
                  height: 25,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CollectionPage(
                                collectionItems: _collectionItems)));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFFF6600)),
                    width: 250,
                    height: 50,
                    child: Center(
                      child: Text(
                        "Перейти к коллекции",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
