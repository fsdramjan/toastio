# Changelog

## 1.1.0

- Added `appIcon` image support using any Flutter `ImageProvider`, including asset, network and memory images, with a fallback for failed image loads.
- Added `accentColor` for the border, glow and icon badge, and `iconColor` for the default icon and custom icons that inherit their color.
- Added custom `icon` and `leading` widgets to the `success`, `error`, `warning` and `info` convenience methods.
- Added configurable `animationDuration` and `reverseAnimationDuration` with smoother fade, slide and scale entrance and exit animations.
- Changed `Toastio.dismiss()` to animate the toast out. Close-button, tap and automatic dismissal use the same exit animation.
- Changed `duration` to represent the display time before the exit animation starts; the exit animation adds to the total lifetime.
- Cancelled dismissal timers when a toast is dismissed or disposed, and ensured replacing a toast cannot let the old toast remove the new one.
- Updated the example app and README with image, color and animation customization.
- Added widget tests for customization, animated dismissal, automatic dismissal and toast replacement.

## 1.0.3

- Fixed README screenshot URLs for pub.dev.
- Improved package documentation.

## 1.0.2

- Renamed `AppToast` to `Toastio`.
- Updated the example app to use the `Toastio` API.
- Fixed toast initialization and usage.

## 1.0.1

- Improved package documentation.
- Updated package metadata and examples.

## 1.0.0

- Initial release of toastio.
