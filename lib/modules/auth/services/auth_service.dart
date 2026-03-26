import 'package:template/core/models/token_model.dart';
import 'package:template/core/services/base_service.dart';

class AuthService extends BaseService {

  Future<Token> authenticate(String email, String password) async {
    var payload = {
      'email': email,
      'password': password
    };

    return await post<Token>(
      '/v1/auth',
      body: payload,
      fromJson: (json) => Token.fromJson(json),
    );
  }

  Future<Token> verify() async {
    return await get<Token>(
      '/v1/auth/verify',
      fromJson: (json) => Token.fromJson(json),
    );
  }
}