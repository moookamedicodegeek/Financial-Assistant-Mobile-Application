import 'dart:math';

class UniqueStringGenerator {
  // Set to store used unique strings
  final Set<String> usedValues = {};

  // Characters allowed in the generated string
  final String _allowedChars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

  // Function to generate a unique string
  String generateUniqueString(int minLength, int maxLength) {
    String uniqueValue;

    do {
      // Generate a random string of length between minLength and maxLength
      uniqueValue = _generateRandomString(minLength, maxLength);
    } while (usedValues.contains(
        uniqueValue)); // Keep generating until a unique value is found

    // Mark the string as used
    usedValues.add(uniqueValue);

    return uniqueValue;
  }

  // Helper function to generate random string of given length
  String _generateRandomString(int minLength, int maxLength) {
    final random = Random();
    final int length = minLength + random.nextInt(maxLength - minLength + 1);

    return List.generate(length, (index) {
      return _allowedChars[random.nextInt(_allowedChars.length)];
    }).join();
  }
}
