import 'package:flutter/material.dart';
import 'screens/gallery_page.dart';

void main() => runApp(const HeroDemo());

class PhotoItem {
  final String title;
  final String description;
  final String asset;

  const PhotoItem({
    required this.title,
    required this.description,
    required this.asset,
  });
}

const List<PhotoItem> photos = [
  PhotoItem(
  title: 'Avatar 1',
  description: 'Avatar 1. Tap back to watch the Hero fly home.',
  asset: 'assets/images/avatar1.jpg',
  ),
  PhotoItem(
  title: 'Avatar 2',
  description: 'Avatar 2. Both screens wrap this image in a Hero with the same tag.',
  asset: 'assets/images/avatar2.jpg',
  ),
  PhotoItem(
  title: 'Avatar 3',
  description: 'Avatar 3. The Navigator pushes a new route and the HeroController '
        'finds the matching tags.',
  asset: 'assets/images/avatar3.jpg',
  ),
  PhotoItem(
  title: 'Avatar 1',
  description: 'Avatar 1 again. Same image as the first tile, but its tag '
      'is "photo-3", so the Hero still works.',
  asset: 'assets/images/avatar1.jpg',
  ),
  PhotoItem(
  title: 'Avatar 2',
  description: 'Avatar 2 again. Tags come from the index, not the image, so '
      'repeated images are safe.',
  asset: 'assets/images/avatar2.jpg',
  ),
  PhotoItem(
  title: 'Avatar 3',
  description: 'Avatar 3 again. Flutter animates both the size and the '
      'position of the Hero.',
  asset: 'assets/images/avatar3.jpg',
  ),
];

// Straight-line flight (default) or a curved arc, depending on the switch.
CreateRectTween? rectTweenFor(bool curved) {
  if (!curved) return null;
  return (Rect? begin, Rect? end) => MaterialRectArcTween(begin: begin, end: end);
}

// Custom flight widgets:
Widget roundedShuttle(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection direction,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  final Hero toHero = toHeroContext.widget as Hero;
  return AnimatedBuilder(
    animation: animation,
    child: toHero.child,
    builder: (context, child) {
      final t = animation.value;
      // Push: grid (rounded) -> detail (square). Pop: the reverse.
      final radius = direction == HeroFlightDirection.push ? 16 * (1 - t) : 16 * t;
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: child,
      );
    },
  );
}

class HeroDemo extends StatelessWidget {
  const HeroDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hero Widget Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const GalleryPage(),
    );
  }
}
