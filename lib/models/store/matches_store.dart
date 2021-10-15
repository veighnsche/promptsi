import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:prompts_game/models/documents/app_match/app_match.dart';
import 'package:prompts_game/services/apis/firebase/auth_api.dart';
import 'package:prompts_game/services/cache/matches_cache.dart';
import 'package:prompts_game/services/cache/mixins/map_cache.dart';

class MatchesStore extends ChangeNotifier with MapCache<AppMatch> {
  UnmodifiableMapView<String, AppMatch> get matches => UnmodifiableMapView(map);

  MatchesStore() {
    setMatches(MatchesCache().toList);
  }

  void setMatches(List<AppMatch>? matches) {
    if (matches != null) {
      for (var match in matches) {
        add(match);
      }
      notifyListeners();
    }
  }

  List<AppMatch> get toList {
    return map.values.toList();
  }

  bool hasMatch(String profileId) {
    if (profileId == AuthApi.uid) {
      return true;
    }
    return map[profileId] != null;
  }
}
