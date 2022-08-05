class User {
  final String? objectId, username, phone, displayName, sessionToken;

  const User(
      {this.objectId,
      this.username,
      this.phone,
      this.sessionToken,
      this.displayName});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
        objectId: parsedJson['objectId'],
        username: parsedJson['username'],
        phone: parsedJson['phone'],
        sessionToken: parsedJson['sessionToken'],
        displayName: parsedJson['displayName']);
  }

  static List<User> userlist = [
    const User(
      objectId: '8Hnsvl1zM4s',
      username: 'asdfmovieguy',
      sessionToken: 'loremipsumdolorsitamet',
      phone: '098765434567890987654',
      displayName: 'static user 1',
    )
  ];
}

class UserAccountRegistryErrorModel extends User {
  final String error;

  UserAccountRegistryErrorModel({required this.error});
}

class UserAccountRegistrySuccessModel extends User {}

class UserAccountSignInErrorModel extends User {
  final String errorMessage;

  UserAccountSignInErrorModel({required this.errorMessage});
}

class UserAccountSignInSuccessModel extends User {}
