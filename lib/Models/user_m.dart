class UserM {
  dynamic uid = '';

  dynamic email = '';
  dynamic firstname = '';
  dynamic lastname = '';
  dynamic address = '';
  dynamic npa = '';
  dynamic localite = '';
  dynamic birthday = '';
  List<String> favRoutes = <String>[];
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
    required List<String> fav,
    this.role,
  }) {
    if (fav.isEmpty) {
      favRoutes = <String>[];
    } else {
      favRoutes = fav;
    }
  }

  List<String> getFavs() {
    return favRoutes;
  }

   void setFavs(List<String> newFavs) {
    favRoutes = newFavs;
  }

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
      fav: List.from(userJson["favRoutes"]),
      role: userJson["role"],
    );
  }

  @override
  String toString() {
    return 'email : $email Full name: $firstname $lastname Full Address: $address $npa $localite Birthday: $birthday,Number of Favs : ${favRoutes.length}, ROLE: $role';
  }
}
