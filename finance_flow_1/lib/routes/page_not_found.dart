import 'package:finance_flow_1/widgets/base_screen.dart';
import 'package:flutter/material.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseScreen(
      title: 'Page not found',
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Text(
                ' 404 \n Page not found ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
