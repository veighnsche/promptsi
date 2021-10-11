import 'package:prompts_game/models/mixins/with_document_reference.dart';

typedef NestedMap<T> = Map<String, Map<String, T>>;

abstract class NestedMapCache<T> {
  final NestedMap<T> _nestedMap = {};

  bool parentHas(String parentId) {
    return _nestedMap[parentId] != null;
  }

  bool exists(String parentId, String id) {
    return _nestedMap[parentId]?[id] != null;
  }

  void add(String parentId, T value, {String? id}) {

    // todo: optimize

    if (!parentHas(parentId)) {
      if (value is WithDocumentReference) {
        _nestedMap[parentId] = {value.id: value};
      } else if (id == null) {
        throw '$value is not an instance of WithDocumentReference, or you forgot to add id';
      } else {
        _nestedMap[parentId] = {id: value};
      }
    } else if (canReplace(parentId, value, _nestedMap)) {
      if (value is WithDocumentReference) {
        _nestedMap[parentId]![value.id] = value;
      } else if (id == null) {
        throw '$value is not an instance of WithDocumentReference, or you forgot to add id';
      } else {
        _nestedMap[parentId]![id] = value;
      }
    }
  }

  List<T> toList(String parentId) {
    return _nestedMap[parentId]!.values.toList();
  }

  T get(String parentId, String id) {
    return _nestedMap[parentId]![id]!;
  }

  bool canReplace(String parentId, T value, Map<String, Map<String, T>> nestedMap, {String? id});
}
