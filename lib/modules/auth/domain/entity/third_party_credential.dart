import 'package:equatable/equatable.dart';

enum ThirdPartyProvider { google, apple }

class ThirdPartyCredential extends Equatable {
  const ThirdPartyCredential({
    required this.provider,
    required this.token,
    this.state,
    this.isFromIos = false,
  });

  // Google: server auth code. Apple: authorization code.
  final String token;
  final ThirdPartyProvider provider;
  // Apple-only fields.
  final String? state;
  final bool isFromIos;

  @override
  List<Object?> get props => [provider, token, state, isFromIos];
}
