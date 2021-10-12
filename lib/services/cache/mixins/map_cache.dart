import 'package:prompts_game/models/mixins/with_document_reference.dart';

abstract class MapCache<T> {
  final Map<String, T> _map = {};

  bool exists(String id) {
    return _map[id] != null;
  }

  void add(T value, {String? id}) {
    if (id == null) {
      if (value is! WithDocumentReference) {
        throw '$value is not an instance of WithDocumentReference, or you forgot to add id';
      } else {
        id = value.id;
      }
    }

    if (!exists(id) || canReplace(id, value)) {
      _map[id] = value;
    }
  }

  T get(String id) {
    return _map[id]!;
  }

  bool canReplace(String id, T value);
}
