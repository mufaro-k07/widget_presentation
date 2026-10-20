# Hero widget demo

A small Flutter app I built to demonstrate the `Hero` widget for a class widget presentation. It shows a photo gallery where tapping a tile makes the image and its title "fly" to a detail screen, with a few switches to make the animation easier to study.

- **Author:** Mufaro Victoria Kunze
- **Course:** Mobile Application Development
- **Date:** 20 September 2026

## What the Hero widget is

`Hero` is a Flutter widget that animates a shared element from one screen (route) to another. You wrap a widget in a `Hero` on both screens and give both the same `tag`. When the `Navigator` pushes or pops a route, the `HeroController` that `MaterialApp` sets up finds every pair of Heroes with matching tags and "flies" each one from its old position and size to its new one in an overlay above both routes. The animation runs on the route's own transition, so I didn't need to write an `AnimationController` or any tweens to get the basic effect.

## What this demo includes

- **Gallery screen** (`GalleryPage`): a two-column grid of six tiles. There are only three local images, so each one is used twice to fill the six tiles. Above the grid are two switches: "Curved flight path" and "Slow motion".
- **Detail screen** (`DetailPage`): a large version of the tapped image, its title, and a short description.

Each tile has two Heroes, and the detail screen has the matching pair:

| Hero  | Tag            | Gallery screen                   | Detail screen                        |
| ----- | -------------- | -------------------------------- | ------------------------------------ |
| Image | `photo-$index` | Rounded image in the grid tile   | Full-width image, 320 px high        |
| Title | `title-$index` | `titleMedium` text under the tile | `headlineMedium` text under the image |

## Customisations I added

- **Curved flight path.** By default a Hero flies in a straight line. The `rectTweenFor(bool curved)` helper in `lib/main.dart` returns a `createRectTween` callback that uses `MaterialRectArcTween`, which makes the Hero travel along an arc instead. It returns `null` when the switch is off, so Flutter falls back to the straight default. The "Curved flight path" switch in `GalleryPage` controls it, and the value is passed to `DetailPage` so both ends of the flight use the same tween.
- **Custom flight shuttle.** `roundedShuttle` in `lib/main.dart` is a `flightShuttleBuilder` that wraps the flying image in a `ClipRRect` and animates the corner radius. On push it goes from 16 (the rounded grid tile) to 0 (the square detail image); on pop it does the reverse. Without it, the corners would jump at the start or end of the flight.
- **Slow motion.** The "Slow motion" switch in `GalleryPage` sets `timeDilation` (from `flutter/scheduler.dart`) to 5.0, which slows every animation in the app so the flight is easy to follow. It is set back to 1.0 when the switch is turned off and when the gallery state is disposed.
- **A second Hero on the title.** The title text has its own Hero, so it flies along with the image. The `Text` is wrapped in a transparent `Material`, because during the flight the text sits in an overlay outside any `Scaffold` and would otherwise show the yellow double underline Flutter uses for text with no `Material` ancestor.
- **Unique tags from the tile index.** Tags are built from the grid index (`photo-$index`, `title-$index`) rather than from the image path. Because the same image appears twice in the grid, using the path as the tag would give two Heroes the same tag on one screen, which Flutter does not allow.

## Project structure and why

```
lib/
  main.dart                  App entry point (main, HeroDemo/MaterialApp), plus the
                             PhotoItem model, the photos list, rectTweenFor and roundedShuttle
  screens/
    gallery_page.dart        Screen A: GalleryPage and _GalleryPageState (grid, switches, navigation)
    detail_page.dart         Screen B: DetailPage (large image, title, description)
assets/
  images/
    avatar1.jpg              Photo used by tiles 1 and 4
    avatar2.jpg              Photo used by tiles 2 and 5
    avatar3.jpg              Photo used by tiles 3 and 6
test/
  widget_test.dart           Smoke test: the app builds and shows the gallery title
```

- I split the two screens out of `main.dart` into `lib/screens/` so each file has one job: `main.dart` starts the app, and each screen file builds one screen.
- `GalleryPage` and `_GalleryPageState` stay together in `gallery_page.dart` because the State class is private (the leading underscore makes it visible only inside its own file).
- In its current state, `main.dart` still holds `PhotoItem`, the `photos` list, and the two helper functions (`rectTweenFor` and `roundedShuttle`). Both screen files import `../main.dart` to use them, and `main.dart` imports `gallery_page.dart`, so there is a circular import. Dart allows this, and the app works, but it isn't the cleanest layout.

**Possible improvement:** move `PhotoItem` into a `lib/models/` file, the `photos` list into a `lib/data/` file, and `rectTweenFor` and `roundedShuttle` into a `lib/utils/` file. The screens would then import those files instead of `main.dart`, which removes the circular import. I have not done this refactor yet.

## Prerequisites

- **Flutter SDK.** `pubspec.yaml` sets the Dart SDK constraint to `^3.13.5` (Dart 3.13.5 or later, below 4.0). It does not pin a Flutter version, so use a Flutter release that bundles a compatible Dart version. `flutter --version` shows both.
- Run `flutter doctor` and fix anything it reports for the platform you want to use.
- What you need for each run option below:
  - **Chrome / web server:** Google Chrome for option 1; any modern browser for option 2.
  - **Android emulator:** Android Studio (or the Android SDK) with at least one emulator (AVD) set up.
  - **Physical Android device:** an Android phone with Developer options and USB debugging turned on, plus a USB cable.

## How to run it locally

1. Clone the repository and move into it:

   ```sh
   git clone https://github.com/mufaro-k07/widget_presentation.git
   cd widget_presentation
   ```

2. Get the dependencies:

   ```sh
   flutter pub get
   ```

3. Pick one of the options below.

**Option 1: Chrome**

```sh
flutter run -d chrome
```

**Option 2: Web server** (useful if the browser window that Flutter launches stays blank)

```sh
flutter run -d web-server --web-port 8080
```

Then open http://localhost:8080 in a normal browser window.

**Option 3: Android emulator**

```sh
flutter emulators
flutter emulators --launch <emulator_id>
flutter run
```

**Option 4: Physical Android device**

Connect the phone with USB debugging enabled, then:

```sh
flutter devices
flutter run -d <device_id>
```

The project contains platform folders for `android/`, `ios/`, `web/`, `windows/`, `macos/` and `linux/` (the default set from `flutter create`). The options above cover web and Android. The iOS and macOS targets need a Mac with Xcode, and I have not tested the iOS, macOS, Windows or Linux builds.

While the app is running, press `r` in the terminal for a hot reload or `R` for a hot restart. After changing `pubspec.yaml` or adding or replacing files in `assets/`, stop the app and run it again; a hot reload is not enough.

## How to test and explore the app

1. Turn on **Slow motion** first, so the flight is easy to see.
2. Tap any tile. The image and the title fly to the detail screen, and the image corners go from rounded to square on the way.
3. Press back and watch the same flight run in reverse.
4. Turn on **Curved flight path**, tap a tile again, and compare the arc with the straight path from before.
5. Tap one of the repeated tiles (4, 5 or 6). They reuse images 1 to 3, but their tags are different, so they animate correctly too.

To run the automated test:

```sh
flutter test
```

`test/widget_test.dart` contains one widget test. It builds `HeroDemo` and checks that the text "Hero Gallery" (the gallery app bar title) appears exactly once. It is a smoke test that the app starts on the gallery screen; it does not test the Hero animation itself.

## Troubleshooting

- **Blank browser window with `flutter run -d chrome`:** try option 2 (`-d web-server`) and open the URL in a normal browser. If the `CHROME_EXECUTABLE` environment variable is set, check that it points at a normal Chrome install.
- **Images not loading:** check that `pubspec.yaml` still has `assets/images/` listed under `flutter: assets:`, that the files are in `assets/images/`, and do a full restart (stop the app and run it again).
- **Hero not animating:** check that the Hero on both screens has exactly the same tag and that the new screen is opened with a page route (such as `MaterialPageRoute`). Hero flights run between page routes, not inside a single screen.

## Image credits

The three photos in `assets/images/` are from [Unsplash](https://unsplash.com). 
[Ferr Studio]
[Avatar1](https://unsplash.com/photos/a-cartoon-character-with-a-weird-haircut-G2Qjx1y9aAM)
[Avatar2](https://unsplash.com/photos/a-cartoon-character-with-pink-hair-and-a-pink-outfit-kApBCRq9EFs)
[Avatar3](https://unsplash.com/photos/a-person-wearing-a-green-frog-costume-Zc-D8Ra9xwE)

## References

- [Hero class (Flutter API documentation)](https://api.flutter.dev/flutter/widgets/Hero-class.html)
- [Hero animations (Flutter documentation)](https://docs.flutter.dev/ui/animations/hero-animations)