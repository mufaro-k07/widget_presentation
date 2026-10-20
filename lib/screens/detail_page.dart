import 'package:flutter/material.dart';
import '../main.dart';

// Screen B
class DetailPage extends StatelessWidget {
  final PhotoItem photo;
  final int index;
  final bool curved;

  const DetailPage({
    super.key,
    required this.photo,
    required this.index,
    required this.curved,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Hero(
            tag: 'photo-$index', // same tag as the grid item
            createRectTween: rectTweenFor(curved),
            flightShuttleBuilder: roundedShuttle,
            child: Image.asset(
              photo.asset,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 320,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'title-$index',
                  createRectTween: rectTweenFor(curved),
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      photo.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  photo.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
