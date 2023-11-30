class User {

  final String ci;
  final String password;
  final String fullName;
  final int phone;
  final String sex;
  final String birthdate;
  final String? bloodGroup;
  final String? assurance;

  User({
    required this.ci,
    required this.password,
    required this.fullName,
    required this.phone,
    required this.sex,
    required this.birthdate,
    this.bloodGroup,
    this.assurance
  });

  Map<String, dynamic> toMap() {
    return {
      'ci': ci,
      'password': password,
      'full_name': fullName,
      'phone': phone,
      'sex': sex,
      'birthdate': birthdate,
      'blood_group': bloodGroup,
      'assurance': assurance,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      ci: map['ci'],
      password: map['password'],
      fullName: map['full_name'],
      phone: map['phone'],
      sex: map['sex'],
      birthdate: map['birthdate'],
      bloodGroup: map['blood_group'],
      assurance: map['assurance'],
    );
  }


}
