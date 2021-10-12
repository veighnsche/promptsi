import 'package:prompts_game/models/mixins/with_document_reference.dart';

typedef NestedMap<T> = Map<String, Map<String, T>>;

abstract class NestedMapCache<T> {
  final NestedMap<T> nestedMap = {};

  bool parentHas(String parentId) {
    return nestedMap[parentId] != null;
  }

  bool exists(String parentId, String id) {
    return nestedMap[parentId]?[id] != null;
  }

  void add(String parentId, T value, {String? id}) {
    if (id == null) {
      if (value is! WithDocumentReference) {
        throw '$value is not an instance of WithDocumentReference, or you forgot to add id';
      } else {
        id = value.id;
      }
    }

    if (!parentHas(parentId)) {
      nestedMap[parentId] = {id: value};
    } else if (!exists(parentId, id) || canReplace(parentId, id, value)) {
      nestedMap[parentId]![id] = value;
    }
  }

  List<T> toList(String parentId) {
    return nestedMap[parentId]!.values.toList();
  }

  T get(String parentId, String id) {
    return nestedMap[parentId]![id]!;
  }

  bool canReplace(String parentId, String id, T value);
}
