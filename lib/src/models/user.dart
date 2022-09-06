class User {
  final String? objectId, username, phone, displayname, sessionToken;

  const User(
      {this.objectId,
      this.username,
      this.phone,
      this.sessionToken,
      this.displayname});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
        objectId: parsedJson['objectId'],
        username: parsedJson['username'],
        phone: parsedJson['phone'],
        sessionToken: parsedJson['sessionToken'],
        displayname: parsedJson['displayname']);
  }

  static List<User> userlist = [
    const User(
      objectId: '8Hnsvl1zM4s',
      username: 'asdfmovieguy',
      sessionToken: 'loremipsumdolorsitamet',
      phone: '098765434567890987654',
      displayname: 'static user 1',
    )
  ];
}

class UserAccountRegistryErrorModel extends User {
  final String error;
  final int errorCode;

  UserAccountRegistryErrorModel({required this.error, required this.errorCode});
}

class UserAccountRegistrySuccessModel extends User {}

class UserAccountSignInErrorModel extends User {
  final int errorCode;

  UserAccountSignInErrorModel({required this.errorCode});
}

class UserAccountSignInSuccessModel extends User {}

class UserAccountEditSuccessModel extends User {
  final User user;

  UserAccountEditSuccessModel({required this.user});
}

class UserAccountEditFailedModel extends User {
  final int errorCode;
  UserAccountEditFailedModel({required this.errorCode});
}
