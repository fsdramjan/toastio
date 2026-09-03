import 'dart:ui';

import 'package:flutter/material.dart';

import 'toast_type.dart';

export 'toast_type.dart';

/// A lightweight animated Glassmorphism toast for Flutter.
///
/// Call [initialize] once with the application's navigator key to enable
/// context-free global toasts.
class Toastio {
  Toastio._();

  static GlobalKey<NavigatorState>? _navigatorKey;
  static OverlayEntry? _current;

  static const Color successColor = Color(0xFF1E40AF);
  static const Color errorColor = Color(0xFFFF4D6A);
  static const Color warningColor = Color(0xFFFFB020);
  static const Color infoColor = Color(0xFF1E40AF);
  static const Color white = Colors.white;

  /// Initializes global toast support.
  ///
  /// Example:
  /// ```dart
  /// final navigatorKey = GlobalKey<NavigatorState>();
  ///
  /// MaterialApp(
  ///   navigatorKey: navigatorKey,
  ///   home: const HomePage(),
  /// );
  ///
  /// Toastio.initialize(navigatorKey);
  /// ```
  static void initialize(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  static OverlayState? _globalOverlay() {
    return _navigatorKey?.currentState?.overlay;
  }

  /// Shows a toast using the application's global navigator overlay.
  static void showGlobal(
    String message, {
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
    String? title,
    Color? bgColor,
    Color? textColor,
    Widget? icon,
    Widget? leading,
    ToastPosition position = ToastPosition.bottom,
    double horizontalMargin = 16,
    double bottomOffset = 50,
    double topOffset = 50,
    double maxWidth = 600,
    bool showCloseButton = true,
    bool dismissOnTap = false,
  }) {
    final overlay = _globalOverlay();
    if (overlay == null) {
      debugPrint(
        '[Toastio] No OverlayState available. '
        'Call Toastio.initialize(navigatorKey) first.',
      );
      return;
    }

    _insert(
      overlay,
      message,
      type: type,
      duration: duration,
      title: title,
      bgColor: bgColor,
      textColor: textColor,
      icon: icon,
      leading: leading,
      position: position,
      horizontalMargin: horizontalMargin,
      bottomOffset: bottomOffset,
      topOffset: topOffset,
      maxWidth: maxWidth,
      showCloseButton: showCloseButton,
      dismissOnTap: dismissOnTap,
    );
  }

  /// Shows a toast using [context]'s nearest overlay.
  static void show(
    BuildContext context,
    String message, {
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
    String? title,
    Color? bgColor,
    Color? textColor,
    Widget? icon,
    Widget? leading,
    ToastPosition position = ToastPosition.bottom,
    double horizontalMargin = 16,
    double bottomOffset = 50,
    double topOffset = 50,
    double maxWidth = 600,
    bool showCloseButton = true,
    bool dismissOnTap = false,
  }) {
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) {
      debugPrint('[Toastio] No Overlay found for the supplied context.');
      return;
    }

    _insert(
      overlay,
      message,
      type: type,
      duration: duration,
      title: title,
      bgColor: bgColor,
      textColor: textColor,
      icon: icon,
      leading: leading,
      position: position,
      horizontalMargin: horizontalMargin,
      bottomOffset: bottomOffset,
      topOffset: topOffset,
      maxWidth: maxWidth,
      showCloseButton: showCloseButton,
      dismissOnTap: dismissOnTap,
    );
  }

  static void success(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    Color? bgColor,
    Color? textColor,
    ToastPosition position = ToastPosition.bottom,
    bool showCloseButton = true,
  }) {
    showGlobal(
      message,
      type: ToastType.success,
      title: title ?? 'Success',
      duration: duration,
      bgColor: bgColor,
      textColor: textColor,
      position: position,
      showCloseButton: showCloseButton,
    );
  }

  static void error(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    Color? bgColor,
    Color? textColor,
    ToastPosition position = ToastPosition.bottom,
    bool showCloseButton = true,
  }) {
    showGlobal(
      message,
      type: ToastType.error,
      title: title ?? 'Error',
      duration: duration,
      bgColor: bgColor,
      textColor: textColor,
      position: position,
      showCloseButton: showCloseButton,
    );
  }

  static void warning(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    Color? bgColor,
    Color? textColor,
    ToastPosition position = ToastPosition.bottom,
    bool showCloseButton = true,
  }) {
    showGlobal(
      message,
      type: ToastType.warning,
      title: title ?? 'Warning',
      duration: duration,
      bgColor: bgColor,
      textColor: textColor,
      position: position,
      showCloseButton: showCloseButton,
    );
  }

  static void info(
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 3),
    Color? bgColor,
    Color? textColor,
    ToastPosition position = ToastPosition.bottom,
    bool showCloseButton = true,
  }) {
    showGlobal(
      message,
      type: ToastType.info,
      title: title,
      duration: duration,
      bgColor: bgColor,
      textColor: textColor,
      position: position,
      showCloseButton: showCloseButton,
    );
  }

  /// Removes the currently visible toast immediately.
  static void dismiss() {
    final entry = _current;
    _current = null;
    entry?.remove();
  }

  static void _insert(
    OverlayState overlay,
    String message, {
    required ToastType type,
    required Duration duration,
    String? title,
    Color? bgColor,
    Color? textColor,
    Widget? icon,
    Widget? leading,
    required ToastPosition position,
    required double horizontalMargin,
    required double bottomOffset,
    required double topOffset,
    required double maxWidth,
    required bool showCloseButton,
    required bool dismissOnTap,
  }) {
    dismiss();

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _ToastWidget(
        message: message,
        title: title,
        type: type,
        duration: duration,
        bgColor: bgColor,
        textColor: textColor,
        icon: icon,
        leading: leading,
        position: position,
        horizontalMargin: horizontalMargin,
        bottomOffset: bottomOffset,
        topOffset: topOffset,
        maxWidth: maxWidth,
        showCloseButton: showCloseButton,
        dismissOnTap: dismissOnTap,
        onDone: () {
          if (_current == entry) {
            _current = null;
            entry.remove();
          }
        },
      ),
    );

    _current = entry;
    overlay.insert(entry);
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final String? title;
  final ToastType type;
  final Duration duration;
  final Color? bgColor;
  final Color? textColor;
  final Widget? icon;
  final Widget? leading;
  final ToastPosition position;
  final double horizontalMargin;
  final double bottomOffset;
  final double topOffset;
  final double maxWidth;
  final bool showCloseButton;
  final bool dismissOnTap;
  final VoidCallback onDone;

  const _ToastWidget({
    required this.message,
    required this.type,
    required this.duration,
    required this.position,
    required this.horizontalMargin,
    required this.bottomOffset,
    required this.topOffset,
    required this.maxWidth,
    required this.showCloseButton,
    required this.dismissOnTap,
    required this.onDone,
    this.title,
    this.bgColor,
    this.textColor,
    this.icon,
    this.leading,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<double> _scale;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _opacity = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scale = Tween<double>(
      begin: 0.86,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _controller.forward();

    final dismissAfter = widget.duration - const Duration(milliseconds: 340);

    Future.delayed(
      dismissAfter.isNegative ? Duration.zero : dismissAfter,
      _dismiss,
    );
  }

  void _dismiss() {
    if (_dismissed || !mounted) return;

    _dismissed = true;

    _controller.reverse().whenComplete(() {
      if (mounted) {
        widget.onDone();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _accent {
    switch (widget.type) {
      case ToastType.success:
        return Toastio.white;
      case ToastType.error:
        return Toastio.errorColor;
      case ToastType.warning:
        return Toastio.warningColor;
      case ToastType.info:
        return Toastio.white;
    }
  }

  Color get _defaultBackground {
    switch (widget.type) {
      case ToastType.success:
        return Color(0xFF1E40AF);
      case ToastType.error:
        return const Color(0xFF8B1E32);
      case ToastType.warning:
        return const Color(0xFF6D5010);
      case ToastType.info:
        return Color(0xFF1E40AF);
    }
  }

  IconData get _iconData {
    switch (widget.type) {
      case ToastType.success:
        return Icons.check_rounded;
      case ToastType.error:
        return Icons.close_rounded;
      case ToastType.warning:
        return Icons.warning_amber_rounded;
      case ToastType.info:
        return Icons.info_outline_rounded;
    }
  }

  Alignment get _alignment {
    switch (widget.position) {
      case ToastPosition.top:
        return Alignment.topCenter;
      case ToastPosition.center:
        return Alignment.center;
      case ToastPosition.bottom:
        return Alignment.bottomCenter;
    }
  }

  Offset get _slideBegin {
    switch (widget.position) {
      case ToastPosition.top:
        return const Offset(0, -0.7);
      case ToastPosition.center:
        return const Offset(0, 0.25);
      case ToastPosition.bottom:
        return const Offset(0, 0.7);
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;

    final horizontal = widget.horizontalMargin * 2;
    final cardWidth = (width - horizontal).clamp(0.0, widget.maxWidth);

    return SafeArea(
      child: Align(
        alignment: _alignment,
        child: Padding(
          padding: EdgeInsets.only(
            left: widget.horizontalMargin,
            right: widget.horizontalMargin,
            top: widget.position == ToastPosition.top ? widget.topOffset : 0,
            bottom: widget.position == ToastPosition.bottom
                ? widget.bottomOffset
                : 0,
          ),
          child: SizedBox(
            width: cardWidth,
            child: Material(
              color: Colors.transparent,
              child: FadeTransition(
                opacity: _opacity,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: _slideBegin,
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                  child: ScaleTransition(
                    scale: _scale,
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: widget.dismissOnTap ? _dismiss : null,
                      child: _GlassCard(
                        bg: widget.bgColor ?? _defaultBackground,
                        accent: _accent,
                        icon: widget.icon ??
                            Icon(
                              _iconData,
                              color: _accent,
                              size: 17,
                            ),
                        leading: widget.leading,
                        title: widget.title,
                        message: widget.message,
                        textColor: widget.textColor ?? Colors.white,
                        showCloseButton: widget.showCloseButton,
                        onClose: _dismiss,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Color bg;
  final Color accent;
  final Widget icon;
  final Widget? leading;
  final String? title;
  final String message;
  final Color textColor;
  final bool showCloseButton;
  final VoidCallback onClose;

  const _GlassCard({
    required this.bg,
    required this.accent,
    required this.icon,
    required this.message,
    required this.textColor,
    required this.showCloseButton,
    required this.onClose,
    this.leading,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          decoration: BoxDecoration(
            color: bg.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: accent.withValues(alpha: 0.20),
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.18),
                blurRadius: 20,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        accent.withValues(alpha: 0.15),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 10,
                bottom: 10,
                child: Container(
                  width: 3.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        accent.withValues(alpha: 0.3),
                        accent,
                        accent.withValues(alpha: 0.3),
                      ],
                    ),
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.55),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 11, 8, 11),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            accent.withValues(alpha: 0.18),
                            accent.withValues(alpha: 0.05),
                          ],
                        ),
                        border: Border.all(
                          color: accent.withValues(alpha: 0.28),
                        ),
                      ),
                      child: Center(child: icon),
                    ),
                    const SizedBox(width: 12),
                    if (leading != null) ...[
                      leading!,
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (title != null) ...[
                            Text(
                              title!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.15,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 3),
                          ],
                          Text(
                            message,
                            style: TextStyle(
                              color: textColor,
                              fontSize: title != null ? 11.5 : 12.5,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                              letterSpacing: 0.05,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (showCloseButton) ...[
                      const SizedBox(width: 4),
                      Semantics(
                        button: true,
                        label: 'Dismiss notification',
                        child: InkWell(
                          onTap: onClose,
                          customBorder: const CircleBorder(),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: textColor.withValues(alpha: 0.12),
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              size: 14,
                              color: textColor.withValues(alpha: 0.85),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
