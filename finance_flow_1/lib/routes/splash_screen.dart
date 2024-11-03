import 'package:finance_flow_1/route_manager.dart';
import 'package:finance_flow_1/theme/theme_data.dart';
import 'package:finance_flow_1/theme/theme_provider.dart';
import 'package:finance_flow_1/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 160,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                Provider.of<ThemeProvider>(context).themeData == lightTheme
                    ? "assets/images/bright_logo.png"
                    : "assets/images/dark_logo.png",
                width: 200,
              ),
              Text(
                "interactive, intuitive and \n innovative solution to solving \n your financial problems",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              const SizedBox(
                height: 150,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Continue to ',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  CustomButton(
                    text: 'Login',
                    color: Theme.of(context).colorScheme.primary,
                    textColor: Theme.of(context).colorScheme.tertiary,
                    onPressed: () => Navigator.of(context)
                        .pushReplacementNamed(RouteManager.login),
                  ),
                ],
              ),
            ],
          ),
        ),
      ), // add two pictures
    );
  }
}
