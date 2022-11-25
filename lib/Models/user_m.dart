class UserM {
  final String uid;

  dynamic email = '';
  dynamic firstname = '';
  dynamic lastname = '';
  dynamic address = '';
  dynamic npa = '';
  dynamic birthday = '';

  UserM(
      {required this.uid,
      this.email,
      this.firstname,
      this.lastname,
      this.address,
      this.npa,
      this.birthday});

  @override
  String toString() {
    return 'email : $email Full name:$firstname $lastname Full Address: $address $npa Birthday: $birthday';
  }
}
