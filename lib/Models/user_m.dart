class UserM {
  final String uid;

  dynamic email = '';
  dynamic firstname = '';
  dynamic lastname = '';
  dynamic address = '';
  dynamic npa = '';
  dynamic localite = '';
  dynamic birthday = '';
  dynamic role = '';


  UserM(
      {required this.uid,
      this.email,
      this.firstname,
      this.lastname,
      this.address,
      this.npa,
      this.localite,
      this.birthday,
      this.role});

  @override
  String toString() {
    return 'email : $email Full name: $firstname $lastname Full Address: $address $npa $localite Birthday: $birthday, ROLE: $role';
  }
}
