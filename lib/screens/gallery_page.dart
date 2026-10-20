import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import '../main.dart';
import 'detail_page.dart';

// Screen A
class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  bool _curved = false;
  bool _slowMotion = false;

  void _setSlowMotion(bool value) {
    setState(() {
      _slowMotion = value;
      // timeDilation slows every animation, which makes the flight easy to see.
      timeDilation = value ? 5.0 : 1.0;
    });
  }

  @override
  void dispose() {
    timeDilation = 1.0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hero Gallery')),
      body: Column(
        children: [
          SwitchListTile(
            dense: true,
            title: const Text('Curved flight path'),
            subtitle: const Text('createRectTween: MaterialRectArcTween'),
            value: _curved,
            onChanged: (v) => setState(() => _curved = v),
          ),
          SwitchListTile(
            dense: true,
            title: const Text('Slow motion'),
            subtitle: const Text('timeDilation = 5.0'),
            value: _slowMotion,
            onChanged: _setSlowMotion,
          ),
          const Divider(height: 1),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final photo = photos[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DetailPage(
                          photo: photo,
                          index: index,
                          curved: _curved,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Hero(
                            tag: 'photo-$index', // must match screen B
                            createRectTween: rectTweenFor(_curved),
                            flightShuttleBuilder: roundedShuttle,
                            child: Image.asset(
                              photo.asset,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Hero(
                        tag: 'title-$index',
                        createRectTween: rectTweenFor(_curved),
                        // Material stops the yellow double-underline that Text
                        // shows when it flies outside a Scaffold.
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            photo.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
