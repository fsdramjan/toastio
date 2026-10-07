[![pub package](https://img.shields.io/pub/v/toastio.svg)](https://pub.dev/packages/toastio)
[![pub points](https://img.shields.io/pub/points/toastio)](https://pub.dev/packages/toastio/score)
[![likes](https://img.shields.io/pub/likes/toastio)](https://pub.dev/packages/toastio)

# toastio

A lightweight, animated Glassmorphism toast package for Flutter with global and context-based APIs.

## Features

- Success, error, warning and info toast types
- Global toast without passing `BuildContext`
- Context-based API
- Glassmorphism UI with blur
- Smooth fade, slide and scale entrance and exit animations with configurable timing
- Close button
- Auto dismiss
- Custom background, text, accent and icon colors
- App icon images from assets, network URLs or memory
- Custom icon and leading widget
- Top, center and bottom positions
- No GetX or other third-party dependencies

## 📸 Screenshots

<p align="center">
  <img src="https://raw.githubusercontent.com/fsdramjan/toastio/main/example/assets/success.png" width="220" alt="Success Toast">
  <img src="https://raw.githubusercontent.com/fsdramjan/toastio/main/example/assets/error.png" width="220" alt="Error Toast">
  <img src="https://raw.githubusercontent.com/fsdramjan/toastio/main/example/assets/warning.png" width="220" alt="Warning Toast">
</p>

<p align="center">
  <img src="https://raw.githubusercontent.com/fsdramjan/toastio/main/example/assets/info.png" width="220" alt="Info Toast">
  <img src="https://raw.githubusercontent.com/fsdramjan/toastio/main/example/assets/top.png" width="220" alt="Top Position Toast">
  <img src="https://raw.githubusercontent.com/fsdramjan/toastio/main/example/assets/image.png" width="220" alt="Toast with Image">
</p>

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  toastio: ^1.1.0
```

Import the package alongside Flutter Material widgets:

```dart
import 'package:flutter/material.dart';
import 'package:toastio/toastio.dart';
```

Then run:

```bash
flutter pub get
```

## Global Setup

Create a navigator key:

```dart
final navigatorKey = GlobalKey<NavigatorState>();
```

Initialize the package:

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Toastio.initialize(navigatorKey);

  runApp(
    MaterialApp(
      navigatorKey: navigatorKey,
      home: const HomePage(),
    ),
  );
}
```

Now you can call a toast from anywhere:

```dart
Toastio.success('Profile updated');

Toastio.error(
  'Something went wrong',
  title: 'Error',
);

Toastio.warning('Please check your input');

Toastio.info('New message received');
```

## Context API

If you already have a `BuildContext`:

```dart
Toastio.show(
  context,
  'Saved successfully',
  type: ToastType.success,
);
```

## Customization

Customize the toast appearance, duration, position, colors, and close button:

```dart
Toastio.showGlobal(
  'Custom toast',
  type: ToastType.info,
  title: 'Information',
  duration: const Duration(seconds: 4),
  bgColor: Colors.black,
  textColor: Colors.white,
  position: ToastPosition.bottom,
  showCloseButton: true,
);
```

### App Image, Icon and Colors

All APIs, including `success`, `error`, `warning` and `info`, support these options:

```dart
Toastio.success(
  'Profile updated',
  appIcon: const AssetImage('assets/app_icon.png'),
  icon: const Icon(Icons.check_circle_outline),
  bgColor: const Color(0xFF16352B),
  textColor: Colors.white,
  accentColor: Colors.tealAccent,
  iconColor: Colors.tealAccent,
  animationDuration: const Duration(milliseconds: 450),
  reverseAnimationDuration: const Duration(milliseconds: 250),
);
```

Register asset images in your app's `pubspec.yaml`. `appIcon` accepts any
`ImageProvider`, including `AssetImage`, `NetworkImage` and `MemoryImage`, and
appears beside the status icon. `leading` supports custom widgets.
`iconColor` colors the default icon and custom icons without an explicit color.
`accentColor` colors the border, glow and icon badge. When `iconColor` is omitted,
the status icon inherits the accent color. An explicit color on a custom `Icon`
takes precedence over `iconColor`.

Register the asset used above:

```yaml
flutter:
  assets:
    - assets/app_icon.png
```

To load an image from a URL, use `appIcon: const NetworkImage('https://example.com/app_icon.png')`.
Images are displayed at 34 x 34 pixels with rounded corners. A failed image load
shows a fallback icon.

Toasts enter and exit with fade, slide and scale animations. `duration` is the
display time before the exit animation begins. Close, tap dismissal and
`Toastio.dismiss()` use the same exit animation. A new toast replaces the old one.

### Available Options

These options are supported by `show`, `showGlobal`, `success`, `error`, `warning`
and `info`:

| Option | Default | Purpose |
| --- | --- | --- |
| `title` | Optional; success/error/warning supply a type title | Heading above the message |
| `duration` | 3 seconds | Display time before exit begins |
| `appIcon` | None | App image shown beside the status icon |
| `icon` | Type-specific icon | Custom status widget |
| `leading` | None | Extra widget before the text |
| `bgColor` | Type-specific background | Card background |
| `textColor` | White | Title, message and close-button color |
| `accentColor` | Type-specific accent | Border, glow and icon badge |
| `iconColor` | Accent color | Inherited status icon color |
| `position` | `ToastPosition.bottom` | Top, center or bottom placement |
| `showCloseButton` | `true` | Show the dismiss button |
| `animationDuration` | 420 milliseconds | Entrance animation timing |
| `reverseAnimationDuration` | 260 milliseconds | Exit animation timing |

`show` and `showGlobal` also accept:

| Option | Default | Purpose |
| --- | --- | --- |
| `type` | `ToastType.info` | Default colors and status icon |
| `dismissOnTap` | `false` | Dismiss when the toast is tapped |
| `horizontalMargin` | 16 | Horizontal spacing in logical pixels |
| `topOffset` | 50 | Extra spacing when positioned at the top |
| `bottomOffset` | 50 | Extra spacing when positioned at the bottom |
| `maxWidth` | 600 | Maximum card width in logical pixels |

### Custom Icon

```dart
Toastio.showGlobal(
  'Upload complete',
  icon: const Icon(Icons.cloud_done),
);
```

### Custom Leading Widget

```dart
Toastio.showGlobal(
  'New message',
  leading: const CircleAvatar(
    radius: 12,
    child: Icon(Icons.person, size: 14),
  ),
);
```

## Dismiss Manually

You can dismiss the currently visible toast manually with its exit animation:

```dart
Toastio.dismiss();
```

## Toast Positions

Toast messages can be displayed at different positions:

```dart
Toastio.showGlobal(
  'Top toast',
  position: ToastPosition.top,
);
```

Available positions:

- `ToastPosition.top`
- `ToastPosition.center`
- `ToastPosition.bottom`

## Duration

Set the display time before automatic dismissal. The exit animation runs afterward:

```dart
Toastio.showGlobal(
  'This toast stays longer',
  duration: const Duration(seconds: 4),
);
```

A 4-second `duration` with the default 260-millisecond exit animation takes
approximately 4.26 seconds from insertion to removal. The entrance animation is
included in `duration`. Durations must be non-negative.

## Animation Timing

```dart
Toastio.showGlobal(
  'Animated notification',
  animationDuration: const Duration(milliseconds: 500),
  reverseAnimationDuration: const Duration(milliseconds: 300),
  dismissOnTap: true,
);
```

Only one toast is shown at a time. Showing another toast replaces the current
one immediately, then animates the new toast in.

## Example

Check the `example/` directory for a complete Flutter example demonstrating the available toast types and customization options.

## Contributing

Contributions are welcome! ❤️

If you have an idea, bug fix, improvement, or new feature, feel free to contribute.

### How to Contribute

1. Fork the repository
2. Create a new branch

```bash
git checkout -b feature/my-feature
```

3. Make your changes
4. Test your changes

```bash
flutter test
```

5. Commit your changes

```bash
git commit -m "Add my feature"
```

6. Push your branch

```bash
git push origin feature/my-feature
```

7. Open a Pull Request

Please keep contributions clean, focused, and consistent with the existing code style.

## Issues & Suggestions

Found a bug or have an idea?

Feel free to open an issue and share your feedback. Every suggestion and contribution is appreciated.

## License

MIT License.
