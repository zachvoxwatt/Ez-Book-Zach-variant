import 'package:ez_book/src/models/user.dart';

import '../networking.dart';

class UserRepository {
  final UserClient usercl;

  UserRepository({required this.usercl});

  Future<User> signin(datagram) async {
    return await usercl.signin(datagram);
  }

  Future<User> getUser(datagram) async {
    return await usercl.getUser(datagram);
  }

  Future<User> register(datagram) async {
    return await usercl.register(datagram);
  }
}
