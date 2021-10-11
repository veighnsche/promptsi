import 'package:prompts_game/models/mixins/with_document_reference.dart';

abstract class MapCache<T> {
  final Map<String, T> _map = {};

  bool exists(String id) {
    return _map[id] != null;
  }

  void add(T map, {String? id}) {

    // todo: optimize

    if (map is WithDocumentReference && (!exists(map.id) || canReplace(map))) {
      _map[map.id] = map;
    } else if (id == null) {
      throw '$map is not an instance of WithDocumentReference, or you forgot to add id';
    } else if (!exists(id) || canReplace(map, id: id)) {
      _map[id] = map;
    }
  }

  T get(String id) {
    return _map[id]!;
  }

  bool canReplace(T map, {String? id});
}
