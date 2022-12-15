class UserM {
   dynamic uid='';

  dynamic email = '';
  dynamic firstname = '';
  dynamic lastname = '';
  dynamic address = '';
  dynamic npa = '';
  dynamic localite = '';
  dynamic birthday = '';
  dynamic role = '';

  UserM({
    this.uid,
    this.email,
    this.firstname,
    this.lastname,
    this.address,
    this.npa,
    this.localite,
    this.birthday,
    this.role,
  });
  
  factory UserM.fromJson(Map<String, dynamic> userJson, String uid) {
    return UserM(
      uid: uid,
      email: userJson["email"],
      firstname: userJson["firstname"],
      lastname: userJson["lastname"],
      address: userJson["address"],
      npa: userJson["npa"],
      localite: userJson["localite"],
      birthday: userJson["birthday"],
      role: userJson["role"],
    );
  }

  @override
  String toString() {
    return 'email : $email Full name: $firstname $lastname Full Address: $address $npa $localite Birthday: $birthday, ROLE: $role';
  }
}
