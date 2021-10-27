import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/src/business/user_images.dart';
import '../generated/protocol.dart';
import 'users.dart';

class Emails {
  static String generatePasswordHash(String password) {
    var salt = Serverpod.instance!.getPassword('email_password_salt') ?? 'serverpod password salt';
    return sha256.convert(utf8.encode(password + salt)).toString();
  }

  static Future<UserInfo?> createUser(Session session, String userName, String email, String password) async {
    var userInfo = UserInfo(
      userIdentifier: email,
      email: email,
      userName: userName,
      created: DateTime.now(),
      scopes: [],
      active: true,
      blocked: false,
    );

    print('creating user');
    var createdUser = await Users.createUser(session, userInfo);
    if (createdUser == null)
      return null;

    print('creating email auth');
    var auth = EmailAuth(
      userId: createdUser.id!,
      email: email,
      hash: generatePasswordHash(password),
    );
    await session.db.insert(auth);

    await UserImages.setDefaultUserImage(session, createdUser.id!);
    createdUser = await Users.findUserByUserId(session, createdUser.id!, useCache: false);

    print('returning created user');
    return createdUser;
  }

  static Future<bool> changePassword(Session session, int userId, String oldPassword, String newPassword) async {
    var auth = (await session.db.findSingleRow(tEmailAuth, where: tEmailAuth.userId.equals(userId))) as EmailAuth?;
    if (auth == null) {
      return false;
    }

    // Check old password
    if (auth.hash != generatePasswordHash(oldPassword)) {
      return false;
    }

    // Update password
    auth.hash = generatePasswordHash(newPassword);
    await session.db.update(auth);

    return true;
  }
}