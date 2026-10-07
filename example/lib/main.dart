import 'package:toastio/toastio.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Toastio.initialize(navigatorKey);
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Toast')),
      body: Center(
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Toastio.success('Profile updated'),
              child: const Text('Success'),
            ),
            ElevatedButton(
              onPressed: () => Toastio.error(
                'Please try again later',
                title: 'Something went wrong',
              ),
              child: const Text('Error'),
            ),
            ElevatedButton(
              onPressed: () => Toastio.warning('Check your input'),
              child: const Text('Warning'),
            ),
            ElevatedButton(
              onPressed: () => Toastio.info(
                'You have a new notification',
                title: 'New notification',
              ),
              child: const Text('Info'),
            ),
            ElevatedButton(
              onPressed: () => Toastio.showGlobal(
                'Top positioned toast',
                type: ToastType.info,
                position: ToastPosition.top,
              ),
              child: const Text('Top'),
            ),
            ElevatedButton(
              onPressed: () => Toastio.showGlobal(
                'Image toast with icon',
                icon: const Icon(Icons.notifications_active_outlined),
                appIcon: const AssetImage('assets/success.png'),
                bgColor: const Color(0xFF16352B),
                accentColor: Colors.tealAccent,
                iconColor: Colors.tealAccent,
                type: ToastType.info,
                position: ToastPosition.top,
              ),
              child: const Text('Image'),
            ),
          ],
        ),
      ),
    );
  }
}
