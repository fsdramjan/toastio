import 'package:toastio/toastio.dart';
import 'package:flutter/material.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppToast.initialize(navigatorKey);
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
              onPressed: () => AppToast.success('Profile updated'),
              child: const Text('Success'),
            ),
            ElevatedButton(
              onPressed: () => AppToast.error(
                'Please try again later',
                title: 'Something went wrong',
              ),
              child: const Text('Error'),
            ),
            ElevatedButton(
              onPressed: () => AppToast.warning('Check your input'),
              child: const Text('Warning'),
            ),
            ElevatedButton(
              onPressed: () => AppToast.info(
                'You have a new notification',
                title: 'New notification',
              ),
              child: const Text('Info'),
            ),
            ElevatedButton(
              onPressed: () => AppToast.showGlobal(
                'Top positioned toast',
                type: ToastType.info,
                position: ToastPosition.top,
              ),
              child: const Text('Top'),
            ),
            ElevatedButton(
              onPressed: () => AppToast.showGlobal(
                'Image toast with icon',
                icon: FlutterLogo(size: 15),
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
