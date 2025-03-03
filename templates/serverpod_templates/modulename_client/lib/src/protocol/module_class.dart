/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class ModuleClass extends _i1.SerializableEntity {
  ModuleClass({
    required this.name,
    required this.data,
  });

  factory ModuleClass.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ModuleClass(
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      data: serializationManager.deserialize<int>(jsonSerialization['data']),
    );
  }

  String name;

  int data;

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'data': data,
    };
  }
}
