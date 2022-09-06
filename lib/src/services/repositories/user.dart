import 'package:ez_book/src/models/user.dart';

import '../networking/user_client.dart';

class UserRepository {
  final UserClient usercl;

  UserRepository({required this.usercl});

  Future<User> signin(datagram) async {
    return await usercl.signin(datagram);
  }

  Future<void> signout(requiredInfo) async {
    return await usercl.signout(requiredInfo);
  }

  Future<User> register(datagram) async {
    return await usercl.register(datagram);
  }

  Future<User> update(requiredInfo, toBeChanged) async {
    return await usercl.update(requiredInfo, toBeChanged);
  }

  Future<bool> delete(requiredInfo) async {
    return await usercl.delete(requiredInfo);
  }
}
