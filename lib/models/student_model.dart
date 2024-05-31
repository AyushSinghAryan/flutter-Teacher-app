class Student {
  String id;
  String name;
  String dob;
  String gender;

  Student({
    required this.id,
    required this.name,
    required this.dob,
    required this.gender,
  });

  // Method to convert Student instance to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dob': dob,
      'gender': gender,
    };
  }

  // Factory method to create Student instance from Firestore document
  factory Student.fromMap(Map<String, dynamic> map, String documentId) {
    return Student(
      id: documentId,
      name: map['name'],
      dob: map['dob'],
      gender: map['gender'],
    );
  }
}
