import 'package:prompts_game/models/mixins/with_document_reference.dart';

abstract class MapCache<T> {
  final Map<String, T> _map = {};

  bool exists(String id) {
    return _map[id] != null;
  }

  void add(T value, {String? id}) {

    // todo: optimize

    if (value is WithDocumentReference && (!exists(value.id) || canReplace(value))) {
      _map[value.id] = value;
    } else if (id == null) {
      throw '$value is not an instance of WithDocumentReference, or you forgot to add id';
    } else if (!exists(id) || canReplace(value, id: id)) {
      _map[id] = value;
    }
  }

  T get(String id) {
    return _map[id]!;
  }

  bool canReplace(T value, {String? id});
}
