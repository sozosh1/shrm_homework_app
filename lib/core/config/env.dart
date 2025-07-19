import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'BEARER_TOKEN', obfuscate: true)
  static String bearerToken = _Env.bearerToken;
}