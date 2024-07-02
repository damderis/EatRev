import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'captured_image_model.dart';

class ListReviewPage extends StatefulWidget {
  final CapturedImageModel capturedImageModel;
  const ListReviewPage({Key? key, required this.capturedImageModel}) : super(key: key);

  @override
  _ListReviewPageState createState() => _ListReviewPageState();
}

class _ListReviewPageState extends State<ListReviewPage> {
  CapturedImageModel? _reviewToDelete;
  List<Map<String, dynamic>> _forYouReviews = [
    {
      'imageUrl': 'assets/images/sushi.jpg',
      'nameOfPlace': 'Sample Restaurant',
      'starRating': 4,
      'description': 'This is a great place to eat.',
      'userName': 'Faridul',
      'userProfileImage': 'assets/images/man_6.png',
    },
    {
      'imageUrl': 'assets/images/pizza.jpg',
      'nameOfPlace': 'Another Place',
      'starRating': 5,
      'description': 'Amazing food and service!',
      'userName': 'Safwan',
      'userProfileImage': 'assets/images/man_7.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Review Page', style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0))),
          backgroundColor: Colors.transparent,
          bottom: TabBar(
            tabs: [
              Tab(text: 'For You'),
              Tab(text: 'My Review'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildForYouTab(),
            _buildMyReviewTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildForYouTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _forYouReviews.map((review) {
            return Column(
              children: [
                _buildReviewCard(
                  imageUrl: review['imageUrl'],
                  nameOfPlace: review['nameOfPlace'],
                  starRating: review['starRating'],
                  description: review['description'],
                  userName: review['userName'],
                  userProfileImage: review['userProfileImage'],
                  isMyReview: false,
                ),
                SizedBox(height: 16),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildReviewCard({
    String? imageUrl,
    String? nameOfPlace,
    int? starRating,
    String? description,
    String? userName,
    String? userProfileImage,
    bool isMyReview = false,
    VoidCallback? onDelete,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (userProfileImage != null)
                      CircleAvatar(
                        backgroundImage: AssetImage(userProfileImage),
                      ),
                    SizedBox(width: 8),
                    Text(
                      userName ?? 'Anonymous',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (!isMyReview)
                      TextButton(
                        onPressed: () {
                          // Add follow functionality here
                        },
                        child: Text('Follow', style: TextStyle(color: Colors.black)),
                      ),
                    IconButton(
                      icon: Icon(Icons.share, color: Colors.black),
                      onPressed: () {
                        // Add share functionality here
                      },
                    ),
                    if (isMyReview)
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: onDelete,
                      ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: imageUrl != null
                      ? DecorationImage(
                          image: AssetImage(imageUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: imageUrl == null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(File(widget.capturedImageModel.imageFile!.path), fit: BoxFit.cover),
                      )
                    : null,
              ),
            ),
            SizedBox(height: 16),
            Text(
              '$nameOfPlace',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '$starRating Star',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '$description',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyReviewTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_reviewToDelete != widget.capturedImageModel)
              _buildReviewCard(
                nameOfPlace: widget.capturedImageModel.nameOfPlace,
                starRating: widget.capturedImageModel.starRating,
                description: widget.capturedImageModel.description,
                userName: 'My Review',
                isMyReview: true,
                onDelete: () {
                  setState(() {
                    _reviewToDelete = widget.capturedImageModel;
                  });
                },
              ),
            if (_reviewToDelete == widget.capturedImageModel)
              Center(
                child: Text(
                  'Add your first review',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ListReviewPage(
      capturedImageModel: CapturedImageModel(
        imageFile: XFile('path/to/image'),
        nameOfPlace: 'Sample Place',
        starRating: 5,
        description: 'Sample description',
      ),
    ),
  ));
}
