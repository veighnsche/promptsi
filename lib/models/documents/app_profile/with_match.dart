import 'package:prompts_game/models/documents/app_match/app_match.dart';
import 'package:prompts_game/services/apis/firebase/auth_api.dart';
import 'package:prompts_game/services/apis/matches_api.dart';

mixin WithMatch {
  String get id;

  Future<bool> get hasMatchAsync async {
    if (id == AuthApi.uid) {
      return true;
    }
    return MatchesApi.fetchMatch(id).then((AppMatch? match) {
      return match != null;
    });
  }

  bool get hasMatch {
    if (id == AuthApi.uid) {
      return true;
    }
    return MatchesApi.hasMatch(id);
  }
}
