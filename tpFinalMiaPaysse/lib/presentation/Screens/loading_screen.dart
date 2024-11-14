import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  static Future<T> showLoadingScreen<T>(
      BuildContext context, Future<T> task) async {
    showDialog(
      context: context,
      builder: (context) => LoadingScreen(),
      barrierDismissible: false,
    );
    return await task.then((value) {
      if (context.mounted) {
        Navigator.pop(context);
      }
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Center(
        child: Stack(
          children: [
            CircularProgressIndicator(
              strokeWidth: 8.0,
              color: const Color.fromARGB(179, 10, 40, 186),
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
