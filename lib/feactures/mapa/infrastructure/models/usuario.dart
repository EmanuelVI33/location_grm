class User {
  String ci;
  String password;
  String fullname;
  int phone;
  String sex;
  String birthdate;
  String? bloodGroup;
  String? assurance;

  User({
    required this.ci,
    required this.password,
    required this.fullname,
    required this.phone,
    required this.sex,
    required this.birthdate,
    this.bloodGroup,
    this.assurance,
  });


  Map<String, dynamic> toMap() {
    return {
      'ci': ci,
      'password': password,
      'fullname': fullname,
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
      fullname: map['fullname'],
      phone: map['phone'],
      sex: map['sex'],
      birthdate: map['birthdate'],
      bloodGroup: map['blood_group'],
      assurance: map['assurance'],
    );
  }


}
