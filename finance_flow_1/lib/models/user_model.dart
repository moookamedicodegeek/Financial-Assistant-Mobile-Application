class UserModel {
  final String uid;
  final String email;
  final String name;
  final String surname;
  final String? iDNumber;
  final String dob; // Use String to match the date format in RTDB
  final String address;
  final String? cardNumber;
  late final String? imageUrl;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.surname,
    this.iDNumber,
    required this.dob,
    required this.address,
    this.cardNumber,
    this.imageUrl,
  });

  // Factory constructor to create a UserModel from a map
  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      email: data['Email'] ?? 'N/A',
      name: data['Name'] ?? 'N/A',
      surname: data['Surname'] ?? 'N/A',
      iDNumber: data['Id'],
      dob: data['DOB'] ?? 'N/A',
      address: data['Address'] ?? 'N/A',
      cardNumber: data['CardNumber'],
      imageUrl: data['ImageUrl'],
    );
  }

  // Method to convert a UserModel to a map for storing in Firebase
  Map<String, dynamic> toMap() {
    return {
      'Uid': uid,
      'Email': email,
      'Name': name,
      'Surname': surname,
      'Id': iDNumber,
      'DOB': dob,
      'Address': address,
      'CardNumber': cardNumber,
      'ImageUrl': imageUrl,
    };
  }
}
