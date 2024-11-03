import 'dart:math';

String generateAccountNumber() {
  final random = Random();
  final number = List.generate(10, (_) => random.nextInt(10)).join();
  return number;
}
