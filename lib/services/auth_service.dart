import 'package:dog_breeds_catalog/models/user.dart';

class AuthService {
  static final Map<String, String> _users = {
    'admin': '123456',
    'user': 'password',
  };

  Future<User?> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (_users.containsKey(username) && _users[username] == password) {
      return User(
        id: username,
        username: username,
        email: '$username@example.com',
      );
    }
    return null;
  }

  Future<User?> signup(String username, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (_users.containsKey(username)) {
      return null; // Usuario ya existe
    }
    
    _users[username] = password;
    return User(
      id: username,
      username: username,
      email: email,
    );
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
